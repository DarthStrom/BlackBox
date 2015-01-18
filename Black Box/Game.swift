//
//  Game.swift
//  Black Box
//
//  Created by Jason Duffy on 1/17/15.
//  Copyright (c) 2015 Peapod Media, llc. All rights reserved.
//

public enum Movement {
    case Hit
    case Miss
    case Reflection
    case Detour(Int)
}

public class Game {
    public var guesses = 0
    var balls = [Bool]()
    
    public init() {
        for i in 0...63 {
            balls.append(false)
        }
    }
    
    public func guess(entry: Int) -> Movement {
        guesses += 1
        switch balls[entry - 1] {
        case true:
            return .Hit
        default:
            return .Miss
        }
    }
    
    public func place(spot: Int) {
        balls[spot] = true
    }
}