//
//  Matrix+Huffman.swift
//  JPEGEncoder
//
//  Created by Sergei Smagleev on 28/09/16.
//  Copyright © 2016 sergeysmagleev. All rights reserved.
//

extension Matrix where T : FloatingPoint {
  
  func zigzagRun() -> [T] {
    var retVal : [T] = []
    var forward = true
    var i = 0, j = 0
    repeat {
      if forward {
        if i == 0 {
          if (j == self.width - 1) {
            i += 1
          } else {
            j += 1
          }
          forward = false
        } else if j == self.width - 1 {
          i += 1
          forward = false
        } else {
          i -= 1
          j += 1
        }
      } else {
        if i == self.height - 1 {
          if (i == self.height - 1) {
            j += 1
          } else {
            i += 1
          }
          forward = true
        } else if (j == 0) {
          i += 1
          forward = true
        } else {
          i += 1
          j -= 1
        }
      }
      retVal.append(self[i, j])
    } while (i < self.height - 1 || j < self.width - 1)
    while (retVal.count > 0 && retVal.last == T(0)) {
      _ = retVal.popLast()
    }
    return retVal
  }
}

