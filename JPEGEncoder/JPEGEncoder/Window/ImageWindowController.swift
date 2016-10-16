//
//  ImageWindowController.swift
//  JPEGEncoder
//
//  Created by Sergei Smagleev on 10/10/16.
//  Copyright © 2016 sergeysmagleev. All rights reserved.
//

import Cocoa

enum ImageWindowState {
  case Idle
  case Loading
}

class ImageWindowController : NSWindowController {
  
  @IBOutlet weak var scrollView: NSScrollView!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
  
  var bitmap : Matrix<RGBPixel>?
  var currentState : ImageWindowState = .Idle
  
  override func windowDidLoad() {
    super.windowDidLoad()
    updateState()
  }
  
  func updateState() {
    switch currentState {
    case .Idle:
      progressIndicator.alphaValue = 0.0
      scrollView.alphaValue = 1.0
    case .Loading:
      progressIndicator.alphaValue = 1.0
      progressIndicator.startAnimation(nil)
      scrollView.alphaValue = 0.0
    }
  }
  
  func setImage(image : NSImage?) {
    if let newimage = image {
      let imageView = NSImageView()
      let size = newimage.size
      scrollView.alphaValue = 1
      scrollView.setFrameSize(size)
      imageView.setFrameSize(size)
      imageView.image = newimage
      scrollView.documentView = imageView
      scrollView.resize(withOldSuperviewSize: self.scrollView.frame.size)
    }
  }
  
  func loadBitmap(fromUrl: URL, completion : @escaping (NSImage?) -> ()) {
    currentState = .Loading
    updateState()
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      let bitmapData : Matrix<RGBPixel>
      do {
        bitmapData = try readBitmapFromFile(file: fromUrl.path)
//        let bytes = try readFile(fromURL: fromUrl)
//        let height = bytes[0]
//        let width = bytes[1]
//        let chunks = try decodeChunks(bytes)
//        bitmapData = try uncompressRGBData(chunks, rows: Int(height), cols: Int(width))
      } catch {
        DispatchQueue.main.async {
          self.currentState = .Idle
          self.updateState()
          completion(nil)
        }
        return
      }
      self.bitmap = bitmapData
      let image = createViewFromBitmapData(bitmapData: bitmapData)
      DispatchQueue.main.async {
        self.currentState = .Idle
        self.updateState()
        completion(image)
      }
    }
  }
  
  func compressImage() {
    //todo change
    let url = URL(fileURLWithPath: "/Users/Shared/file.cbt_jpeg")
    guard let bitmap = self.bitmap else {
      return
    }
    currentState = .Loading
    updateState()
    do {
      let pixels = try compressRGBData(bitmap)
      let binaryData = try encodeChunks(pixels,
                                        rows: Int(ceil(Double(bitmap.height) / 8.0)),
                                        cols: Int(ceil(Double(bitmap.width) / 8.0)))
      try writeToFile(toURL: url, source: binaryData)
      print("compression byte count: \(binaryData.count)")
      
    } catch {
      currentState = .Idle
      updateState()
      print("failed to compress")
      return
    }
    print("saved to a file")
  }
  
  public func loadImage(_ fromURL: URL) {
    if currentState == .Loading {
      return
    }
    loadBitmap(fromUrl: fromURL) { [unowned self] image in
      self.setImage(image: image)
    }
  }
  
  public func exportImageToJpeg() {
    compressImage()
  }
}
