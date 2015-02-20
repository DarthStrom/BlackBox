//
//  EntryPoint.swift
//  Black Box
//
//  Created by Jason Duffy on 1/21/15.
//  Copyright (c) 2015 Peapod Media, llc. All rights reserved.
//

import SpriteKit

class EntryPoint: SKSpriteNode {
  var number = 0
  
  class func entryPoint(number: Int, imageNamed: String) -> EntryPoint {
    let sprite = EntryPoint(imageNamed: imageNamed)
    
    sprite.number = number
    sprite.name = "Entry\(number)"
    return sprite
  }
}