//
//  Game.swift
//  Black Box
//
//  Created by Jason Duffy on 1/17/15.
//  Copyright (c) 2015 Peapod Media, llc. All rights reserved.
//

public class Game {
    public var guesses = 0
    let board = Board()
    
    public init() {}
    
    public func guess(entry: Int) -> ExitResult? {
        guesses += 1
        
        switch entry {
        case 1...8:
            return shoot((-1, entry - 1), direction: .Right)
        case 9...16:
            return shoot((entry - 9, 8), direction: .Up)
        case 17...24:
            return shoot((8, 24 - entry), direction: .Left)
        case 25...32:
            return shoot((32 - entry, -1), direction: .Down)
        default:
            return nil
        }
    }
    
    public func place(x: Int, y: Int) {
        board.place(x, y: y)
    }
    
    func shoot(start: (x: Int, y: Int), direction startingDirection: Direction) -> ExitResult? {
        var inBox = true
        var position = (x: start.x, y: start.y)
        var direction = startingDirection
        
        if willDetour((start.x, start.y), direction: direction) {
            return .Reflection
        }
        position = getNewPosition(position, direction: direction)
        while(inBox) {
            if willHit((position.x, y: position.y), direction: direction) {
                return .Hit
            }
            if willReflect((position.x, y: position.y), direction: direction) {
                return .Reflection
            }
            
            direction = getNewDirection((position.x, position.y), direction: direction)

            position = getNewPosition(position, direction: direction)
            inBox = !didExit(position)
        }
        if let exitPoint = board.getExitPoint(position.x, y: position.y) {
            return .Detour(exitPoint)
        }
        return nil
    }
    
    func getNewPosition(position: (x: Int, y: Int), direction: Direction) -> (x: Int, y: Int) {
        switch direction {
        case .Up:
            return (position.x, position.y - 1)
        case .Down:
            return (position.x, position.y + 1)
        case .Left:
            return (position.x - 1, position.y)
        case .Right:
            return (position.x + 1, position.y)
        }
    }
    
    func willHit(position: (x: Int, y: Int), direction: Direction) -> Bool {
        if let currentSpot = board.getSlot(position.x, y: position.y) {
            if currentSpot {
                return true
            }
        }
        switch direction {
        case .Up:
            if let result = board.getSlot(position.x, y: position.y - 1) {
                return result
            }
        case .Down:
            if let result = board.getSlot(position.x, y: position.y + 1) {
                return result
            }
        case .Left:
            if let result = board.getSlot(position.x - 1, y: position.y) {
                return result
            }
        case .Right:
            if let result = board.getSlot(position.x + 1, y: position.y) {
                return result
            }
        }
        return false
    }
    
    func willDetour(position: (x: Int, y: Int), direction: Direction) -> Bool {
        let newDirection = getNewDirection((position.x, position.y), direction: direction)
        return newDirection != direction
    }
    
    func getNewDirection(position: (x: Int, y: Int), direction: Direction) -> Direction {
        switch direction {
        case .Up:
            if let leftBall = board.getSlot(position.x - 1, y: position.y - 1) {
                if leftBall {
                    return .Right
                }
            }
            if let rightBall = board.getSlot(position.x + 1, y: position.y - 1) {
                if rightBall {
                    return .Left
                }
            }
        case .Down:
            if let leftBall = board.getSlot(position.x - 1, y: position.y + 1) {
                if leftBall {
                    return .Right
                }
            }
            if let rightBall = board.getSlot(position.x + 1, y: position.y + 1) {
                if rightBall {
                    return .Left
                }
            }
        case .Left:
            if let topBall = board.getSlot(position.x - 1, y: position.y - 1) {
                if topBall {
                    return .Down
                }
            }
            if let bottomBall = board.getSlot(position.x - 1, y: position.y + 1) {
                if bottomBall {
                    return .Up
                }
            }
        case .Right:
            if let topBall = board.getSlot(position.x + 1, y: position.y - 1) {
                if topBall {
                    return .Down
                }
            }
            if let bottomBall = board.getSlot(position.x + 1, y: position.y + 1) {
                if bottomBall {
                    return .Up
                }
            }
        }
        return direction
    }
    
    func willReflect(position: (x: Int, y: Int), direction: Direction) -> Bool {
        switch direction {
        case .Up:
            if let leftBall = board.getSlot(position.x-1, y: position.y-1) {
                if let rightBall = board.getSlot(position.x+1, y: position.y-1) {
                    return leftBall && rightBall
                }
            }
        case .Down:
            if let leftBall = board.getSlot(position.x-1, y: position.y+1) {
                if let rightBall = board.getSlot(position.x+1, y: position.y+1) {
                    return leftBall && rightBall
                }
            }
        case .Left:
            if let topBall = board.getSlot(position.x-1, y: position.y-1) {
                if let bottomBall = board.getSlot(position.x-1, y: position.y+1) {
                    return topBall && bottomBall
                }
            }
        case .Right:
            if let topBall = board.getSlot(position.x+1, y: position.y-1) {
                if let bottomBall = board.getSlot(position.x+1, y: position.y+1) {
                    return topBall && bottomBall
                }
            }
        }
        return false
    }
    
    func didExit(position: (x: Int, y: Int)) -> Bool {
        return position.x < 0 || position.x > 7 || position.y < 0 || position.y > 7
    }
}