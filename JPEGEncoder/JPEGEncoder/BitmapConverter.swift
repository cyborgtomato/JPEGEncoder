//
//  BitmapConverter.swift
//  JPEGEncoder
//
//  Created by Sergei Smagleev on 12/10/16.
//  Copyright © 2016 sergeysmagleev. All rights reserved.
//

import Foundation

public func divideBitmapToChunks(matrix : Matrix<Float>) -> Matrix<Matrix<Float>> {
  let verticalCount = Int(ceilf(Float(matrix.height) / 8))
  let horizontalCount = Int(ceilf(Float(matrix.width) / 8))
  var retVal : [[Matrix<Float>]] = []
  for i in 0 ..< verticalCount {
    var row = [Matrix<Float>]()
    for j in 0 ..< horizontalCount {
      var segment : [[Float]] = []
      for k : Int in 0 ..< 8 {
        var segmentRow : [Float] = []
        for l : Int in 0 ..< 8 {
          if i * 8 + k >= matrix.height {
            segmentRow.append(0.0)
          } else if j * 8 + l >= matrix.width {
            segmentRow.append(0.0)
          } else {
            segmentRow.append(matrix[i * 8 + k, j * 8 + l])
          }
        }
        segment.append(segmentRow)
      }
      row.append(Matrix(segment))
    }
    retVal.append(row)
  }
  return Matrix(retVal)
}
