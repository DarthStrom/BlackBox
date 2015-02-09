//
//  Game.swift
//  Black Box
//
//  Created by Jason Duffy on 1/17/15.
//  Copyright (c) 2015 Peapod Media, llc. All rights reserved.
//

public enum Exit {
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

public class Game {
    public var guesses = 0
    var balls = [[Bool]](count: 8, repeatedValue: [Bool](count: 8, repeatedValue: false))
    
    public init () {}
    
    public func guess(entry: Int) -> Exit {
        guesses += 1
        switch side(entry)! {
        case .Left:
            return shoot(entry, x: 0, y: entry - 1, xDelta: 1, yDelta: 0)
        case .Bottom:
            return shoot(entry, x: entry - 9, y: 7, xDelta: 0, yDelta: -1)
        case .Right:
            return shoot(entry, x: 7, y: 24 - entry, xDelta: -1, yDelta: 0)
        case .Top:
            return shoot(entry, x: 32 - entry, y: 0, xDelta: 0, yDelta: 1)
        }
    }
    
    public func place(x: Int, y: Int) {
        balls[x][y] = true
    }
    
    func shoot(entry: Int, x: Int, y: Int, xDelta: Int, yDelta: Int) -> Exit {
        var inBox = true
        var position = (x: x, y: y)
        if preEntryReflection(x, y: y, xDelta: xDelta, yDelta: yDelta) {
            return .Reflection
        }
        while(inBox) {
            if balls[position.x][position.y] {
                return .Hit
            }
            if willReflect(position.x, y: position.y, xDelta: xDelta, yDelta: yDelta) {
                return .Reflection
            }
            inBox = !didExit(position.x + xDelta, y: position.y + yDelta)
            position = (position.x + xDelta, position.y + yDelta)
        }
        return .Miss(exitPointForMiss(entry))
    }
    
    func preEntryReflection(x: Int, y: Int, xDelta: Int, yDelta: Int) -> Bool {
        switch (x-1 < 0, x+1 > 7, y-1 < 0, y+1 > 7, xDelta, yDelta) {
        case (true, _, _, _, 0, _):
            return balls[x+1][y]
        case (_, true, _, _, 0, _):
            return balls[x-1][y]
        case (false, false, _, _, 0, _):
            return balls[x-1][y] || balls[x+1][y]
        case (_, _, true, _, _, 0):
            return balls[x][y+1]
        case (_, _, _, true, _, 0):
            return balls[x][y-1]
        case (_, _, false, false, _, 0):
            return balls[x][y-1] || balls[x][y+1]
        default:
            return false
        }
    }
    
    func willReflect(x: Int, y: Int, xDelta: Int, yDelta: Int) -> Bool {
        switch (x-1 < 0, x+1 > 7, y-1 < 0, y+1 > 7, xDelta, yDelta) {
        case (true, _, _, _, 0, _):
            return false
        case (_, true, _, _, 0, _):
            return false
        case (false, false, _, _, 0, _):
            return balls[x-1][y] && balls[x+1][y]
        case (_, _, true, _, _, 0):
            return false
        case (_, _, _, true, _, 0):
            return false
        case (_, _, false, false, _, 0):
            return balls[x][y-1] && balls[x][y+1]
        default:
            return false
        }
    }
    
    func exitPointForMiss(entry: Int) -> Int {
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