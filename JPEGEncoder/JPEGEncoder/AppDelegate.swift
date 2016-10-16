//
//  AppDelegate.swift
//  JPEGEncoder
//
//  Created by Sergei Smagleev on 23/09/16.
//  Copyright © 2016 sergeysmagleev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var imageWindowController : ImageWindowController!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    imageWindowController = ImageWindowController(windowNibName: "ImageWindow")
    imageWindowController.showWindow(self)
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
  }
  
  override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
    let selector = menuItem.action
    
    if (selector == #selector(openFile(_:))) {
      return true
    }
    if (selector == #selector(exportFile(_:))) {
      return true
    }
    return false
  }
  
  @IBAction func openFile(_ sender: AnyObject) {
    let openPanel = NSOpenPanel()
    openPanel.title = "Choose a bitmap file"
    openPanel.showsResizeIndicator = true
    openPanel.showsHiddenFiles = false
    openPanel.canChooseDirectories = false
    openPanel.canCreateDirectories = false
    openPanel.allowsMultipleSelection = false
    openPanel.allowedFileTypes = ["cbt_jpeg", "bmp"]
    
    if (openPanel.runModal() == NSModalResponseOK) {
      guard let result = openPanel.url else {
        return
      }
      imageWindowController.loadImage(result)
    }
  }
  
  @IBAction func exportFile(_ sender: AnyObject) {
    imageWindowController.exportImageToJpeg()
  }
}

