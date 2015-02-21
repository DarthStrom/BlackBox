//
//  Location.swift
//  Black Box
//
//  Created by Jason Duffy on 2/18/15.
//  Copyright (c) 2015 Peapod Media, llc. All rights reserved.
//

public func ==(lhs: Location, rhs: Location) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}

public class Location {
  let x: Int, y: Int
  
  public init (x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

// MARK: - Hashable
extension Location: Hashable {
  public var hashValue: Int {
    return x.hashValue ^ y.hashValue
  }
}