//
//  Matrix.swift
//  JPEGEncoder
//
//  Created by Sergei Smagleev on 23/09/16.
//  Copyright © 2016 sergeysmagleev. All rights reserved.
//

public enum MatrixErrors : Error {
  case sizesDontMatch
}

public class Matrix<T : Equatable> : Sequence, IteratorProtocol, Equatable {
  
  open let data : [[T]]
  private var iteratorIndex = 0
  
  init(_ data : [[T]]) {
    self.data = data
  }
  
  public var height : Int {
    get {
      return data.count
    }
  }
  
  public var width : Int {
    get {
      guard let firstRow = data.first else {
        return 0
      }
      return firstRow.count
    }
  }
  
  public subscript(i : Int, j : Int) -> T {
    return data[i][j]
  }
  
  public func next() -> T? {
    guard let width = data.first?.count else {
      return nil
    }
    guard iteratorIndex < width * data.count else {
      return nil
    }
    defer { iteratorIndex += 1 }
    return data[iteratorIndex / width][iteratorIndex % width]
  }
  
}

extension Matrix where T : FloatingPoint {
  
  convenience init(width : Int, height : Int) {
    let temp : [Int] = Array(repeating: 0, count: height)
    self.init(temp.map { _ in Array(repeating: T(0), count: width) })
  }
  
  public func transpose() -> Matrix<T> {
    var retVal : [[T]] = []
    for i in 0..<width {
      var row : [T] = []
      for j in 0..<height {
        row.append(data[j][i])
      }
      retVal.append(row)
    }
    return Matrix(retVal)
  }
  
  public func equalTo(_ matrix: Matrix<T>, precision: T) -> Bool {
    for (leftElement, rightElement) in zip(self, matrix) {
      if (abs(leftElement - rightElement) > precision) {
        return false
      }
    }
    return true
  }
}

public func ==<T : Equatable> (left : Matrix<T>, right : Matrix<T>) -> Bool {
  if (left.height != right.height || left.width != right.width) {
    return false
  }
  for (leftElement, rightElement) in zip(left, right) {
    if (leftElement != rightElement) {
      return false
    }
  }
  return true
}

public func ==<T : Equatable> (left : Matrix<T>, right : Matrix<T>) -> Bool where T : FloatingPoint {
  if (left.height != right.height || left.width != right.width) {
    return false
  }
  let precision = T(1) / T(100)
  for (leftElement, rightElement) in zip(left, right) {
    if (abs(leftElement - rightElement) > precision) {
      return false
    }
  }
  return true
}

func *<T : FloatingPoint> (left : Matrix<T>, right : Matrix<T>) throws -> Matrix<T> {
  guard left.width == right.height else {
    throw MatrixErrors.sizesDontMatch
  }
  var retVal : [[T]] = []
  let destHeight = left.height, destWidth = right.width, additives = left.width
  for i in 0..<destHeight {
    var row: [T] = []
    for j in 0..<destWidth {
      var sum : T = T(0)
      for k in 0..<additives {
        sum += left[i, k] * right[k, j]
      }
      row.append(sum)
    }
    retVal.append(row)
  }
  return Matrix(retVal)
}

func +<T : FloatingPoint> (left : Matrix<T>, right : Matrix<T>) throws -> Matrix<T> {
  guard left.height == right.height && left.width == right.width else {
    throw MatrixErrors.sizesDontMatch
  }
  var retVal : [[T]] = []
  for i in 0..<left.height {
    var row : [T] = []
    for j in 0..<left.width {
      row.append(left[i, j] + right[i, j])
    }
    retVal.append(row)
  }
  return Matrix(retVal)
}

func -<T : FloatingPoint> (left : Matrix<T>, right : Matrix<T>) throws -> Matrix<T> {
  guard left.height == right.height && left.width == right.width else {
    throw MatrixErrors.sizesDontMatch
  }
  var retVal : [[T]] = []
  for i in 0..<left.height {
    var row : [T] = []
    for j in 0..<left.width {
      row.append(left[i, j] - right[i, j])
    }
    retVal.append(row)
  }
  return Matrix(retVal)
}

public func quantize(_ left: Matrix<Double>, by right: Matrix<Int>) throws -> Matrix<Int> {
  guard left.height == right.height && left.width == right.width else {
    throw MatrixErrors.sizesDontMatch
  }
  var retVal : [[Int]] = []
  for i in 0..<left.height {
    var row : [Int] = []
    for j in 0..<left.width {
      row.append(Int(left[i, j] / Double(right[i, j])))
    }
    retVal.append(row)
  }
  return Matrix(retVal)
}

public func dequantize(_ left: Matrix<Int>, by right: Matrix<Int>) throws -> Matrix<Double> {
  guard left.height == right.height && left.width == right.width else {
    throw MatrixErrors.sizesDontMatch
  }
  var retVal : [[Double]] = []
  for i in 0..<left.height {
    var row : [Double] = []
    for j in 0..<left.width {
      row.append(Double(left[i, j] * right[i, j]))
    }
    retVal.append(row)
  }
  return Matrix(retVal)
}
