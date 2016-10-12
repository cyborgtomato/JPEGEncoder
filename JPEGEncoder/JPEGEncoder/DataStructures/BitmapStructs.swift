//
//  BitmapStructs.swift
//  JPEGEncoder
//
//  Created by Sergei Smagleev on 10/10/16.
//  Copyright © 2016 sergeysmagleev. All rights reserved.
//

public struct FileHeader {
  var fileSize : Int32
  var reservedWord1 : Int16
  var reservedWord2 : Int16
  var dataOffset : Int32
}

public struct BitmapHeader {
  var size : Int32
  var width : Int32
  var height : Int32
  var bitPlanes : Int16
  var colorDepth : Int16
  var compression : Int32
  var imageSize : Int32
  var xppm : Int32
  var yppm : Int32
  var usedColors : Int32
  var importantColors : Int32
}

public struct RGBPixel : Equatable {
  var red : UInt8
  var green : UInt8
  var blue : UInt8
  var alpha : UInt8
}

public func emptyPixel() -> RGBPixel {
  return RGBPixel(red: 0, green: 0, blue: 0, alpha: 0)
}

public func ==(lhs : RGBPixel, rhs : RGBPixel) -> Bool {
  return lhs.red == rhs.red &&
    lhs.green == rhs.green &&
    lhs.blue == rhs.blue &&
    lhs.alpha == rhs.alpha
}

