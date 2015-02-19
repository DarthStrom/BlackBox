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
            if board.getSlot(position.x, y: position.y) || willHit(position, direction: direction) {
                return .Hit
            }
            if willReflect(position, direction: direction) {
                return .Reflection
            }
            
            let newDirection = getNewDirection(position, direction: direction)
            let newPosition = getNewPosition(position, direction: newDirection)
            
            return shootFrom(newPosition, direction: newDirection)
        }
        if let exitPoint = board.getEntryPoint(position.x, y: position.y) {
            return .Detour(exitPoint)
        }
        return nil
    }
    
    func willDetour(position: Location, direction: Direction) -> Bool {
        let newDirection = getNewDirection(position, direction: direction)
        return newDirection != direction
    }
    
    func willHit(position: Location, direction: Direction) -> Bool {
        switch direction {
        case .Up:
            return board.getSlot(position.x, y: position.y - 1)
        case .Down:
            return board.getSlot(position.x, y: position.y + 1)
        case .Left:
            return board.getSlot(position.x - 1, y: position.y)
        case .Right:
            return board.getSlot(position.x + 1, y: position.y)
        }
    }
    
    func willReflect(position: Location, direction: Direction) -> Bool {
        switch direction {
        case .Up:
            return board.getSlot(position.x - 1, y: position.y - 1) &&
                board.getSlot(position.x + 1, y: position.y - 1)
        case .Down:
            return board.getSlot(position.x - 1, y: position.y + 1) &&
                board.getSlot(position.x + 1, y: position.y + 1)
        case .Left:
            return board.getSlot(position.x - 1, y: position.y - 1) &&
                board.getSlot(position.x - 1, y: position.y + 1)
        case .Right:
            return board.getSlot(position.x + 1, y: position.y - 1) &&
                board.getSlot(position.x + 1, y: position.y + 1)
        }
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
            if board.getSlot(position.x - 1, y: position.y - 1) {
                return .Right
            }
            if board.getSlot(position.x + 1, y: position.y - 1) {
                return .Left
            }
        case .Down:
            if board.getSlot(position.x - 1, y: position.y + 1) {
                return .Right
            }
            if board.getSlot(position.x + 1, y: position.y + 1) {
                return .Left
            }
        case .Left:
            if board.getSlot(position.x - 1, y: position.y - 1) {
                return .Down
            }
            if board.getSlot(position.x - 1, y: position.y + 1) {
                return .Up
            }
        case .Right:
            if board.getSlot(position.x + 1, y: position.y - 1) {
                return .Down
            }
            if board.getSlot(position.x + 1, y: position.y + 1) {
                return .Up
            }
        }
        return direction
    }
}