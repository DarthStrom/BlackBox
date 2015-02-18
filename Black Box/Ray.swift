//
//  Ray.swift
//  Black Box
//
//  Created by Jason Duffy on 2/18/15.
//  Copyright (c) 2015 Peapod Media, llc. All rights reserved.
//

class Ray {
    let entry: Int
    let board: Board
    
    init(entry: Int, board: Board) {
        self.entry = entry
        self.board = board
    }
    
    func shoot() -> ExitResult? {
        if var position = board.getLocationForEntry(entry) {
            if var direction = board.getDirectionForEntry(entry) {
                if willDetour(position, direction: direction) {
                    return .Reflection
                }
                position = getNewPosition(position, direction: direction)
                return shootFrom(position, direction: direction)
            }
        }
        return nil
    }
    
    func shootFrom(position: Location, direction: Direction) -> ExitResult? {
        if board.isInBox(position) {
            if willHit(position, direction: direction) {
                return .Hit
            }
            if willReflect(position, direction: direction) {
                return .Reflection
            }
            
            let newDirection = getNewDirection(position, direction: direction)
            let newPosition = getNewPosition(position, direction: newDirection)
            
            return shootFrom(newPosition, direction: newDirection)
        }
        if let exitPoint = board.getExitPoint(position.x, y: position.y) {
            return .Detour(exitPoint)
        }
        return nil
    }
    
    func willDetour(position: Location, direction: Direction) -> Bool {
        let newDirection = getNewDirection(position, direction: direction)
        return newDirection != direction
    }
    
    func willHit(position: Location, direction: Direction) -> Bool {
        if let currentPosition = board.getSlot(position.x, y: position.y) {
            if currentPosition {
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
    
    func willReflect(position: Location, direction: Direction) -> Bool {
        switch direction {
        case .Up:
            if let leftBall = board.getSlot(position.x - 1, y: position.y - 1) {
                if let rightBall = board.getSlot(position.x + 1, y: position.y - 1) {
                    return leftBall && rightBall
                }
            }
        case .Down:
            if let leftBall = board.getSlot(position.x - 1, y: position.y + 1) {
                if let rightBall = board.getSlot(position.x + 1, y: position.y + 1) {
                    return leftBall && rightBall
                }
            }
        case .Left:
            if let topBall = board.getSlot(position.x - 1, y: position.y - 1) {
                if let bottomBall = board.getSlot(position.x - 1, y: position.y + 1) {
                    return topBall && bottomBall
                }
            }
        case .Right:
            if let topBall = board.getSlot(position.x + 1, y: position.y - 1) {
                if let bottomBall = board.getSlot(position.x + 1, y: position.y + 1) {
                    return topBall && bottomBall
                }
            }
        }
        return false
    }
    
    func getNewPosition(position: Location, direction: Direction) -> Location {
        switch direction {
        case .Up:
            return Location(x: position.x, y: position.y - 1)
        case .Down:
            return Location(x: position.x, y: position.y + 1)
        case .Left:
            return Location(x: position.x - 1, y: position.y)
        case .Right:
            return Location(x: position.x + 1, y: position.y)
        }
    }
    
    func getNewDirection(position: Location, direction: Direction) -> Direction {
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
}