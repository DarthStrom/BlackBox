//
//  Game.swift
//  Black Box
//
//  Created by Jason Duffy on 1/17/15.
//  Copyright (c) 2015 Peapod Media, llc. All rights reserved.
//

public enum Movement {
    case Hit
    case Miss(Int)
    case Reflection
    case Detour(Int)
}

enum Side {
    case Left
    case Bottom
    case Right
    case Top
}

class Slot {
    let x: Int
    let y: Int
    var filled: Bool
    
    init(x: Int, y: Int, filled: Bool) {
        self.x = x
        self.y = y
        self.filled = filled
    }
}

public class Game {
    public var guesses = 0
    var balls = [Slot]()
    
    public init() {
        for y in 0...7 {
            for x in 0...7 {
                balls.append(Slot(x: x, y: y, filled: false))
            }
        }
    }
    
    public func guess(entry: Int) -> Movement {
        guesses += 1
        switch side(entry)! {
        case .Left:
            return move(entry, initialPosition: (entry - 1) * 8, positionDelta: 1, xDelta: 1, yDelta: 0)
        case .Bottom:
            return move(entry, initialPosition: entry + 47, positionDelta: -8, xDelta: 0, yDelta: -1)
        case .Right:
            return move(entry, initialPosition: (25 - entry) * 8 - 1, positionDelta: -1, xDelta: -1, yDelta: 0)
        case .Top:
            return move(entry, initialPosition: 32 - entry, positionDelta: 8, xDelta: 0, yDelta: 1)
        }
    }
    
    public func place(spot: Int) {
        balls[spot].filled = true
    }
    
    func move(entry: Int, initialPosition: Int, positionDelta: Int, xDelta: Int, yDelta: Int) -> Movement {
        var inBox = true
        var position = initialPosition
        while(inBox) {
            if balls[position].filled {
                return .Hit
            }
            inBox = !didExit(balls[position].x + xDelta, y: balls[position].y + yDelta)
            position += positionDelta
        }
        return .Miss(exitForMiss(entry))
    }
    
    func exitForMiss(entry: Int) -> Int {
        switch side(entry)! {
        case .Left, .Right:
            return 25 - entry
        case .Bottom, .Top:
            return 41 - entry
        default:
            return 0
        }
    }
    
    func didExit(x: Int, y: Int) -> Bool {
        return x < 0 || x > 7 || y < 0 || y > 7
    }
    
    func side(entry: Int) -> Side? {
        switch entry {
        case 1...8:
            return .Left
        case 9...16:
            return .Bottom
        case 17...24:
            return .Right
        case 25...32:
            return .Top
        default:
            println("Expected entry point between 1 and 32")
            return nil
        }
    }
}