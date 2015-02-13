//
//  Game.swift
//  Black Box
//
//  Created by Jason Duffy on 1/17/15.
//  Copyright (c) 2015 Peapod Media, llc. All rights reserved.
//

public enum Exit {
    case None
    case Hit
    case Reflection
    case Detour(Int)
}

enum Direction {
    case Up
    case Down
    case Left
    case Right
}


struct Point: Hashable {
    let x: Int
    let y: Int
    
    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    
    init (x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public class Game {
    public var guesses = 0
    var balls = [Point: Bool]()
    var entryPointsLookup = [Point: Int]()
    
    public init () {
        populateBalls()
        populateEntryPoints()
    }
    
    func populateBalls() {
        for y in 0...7 {
            for x in 0...7 {
                balls[Point(x: x, y: y)] = false
            }
        }
    }
    
    func populateEntryPoints() {
        for n in 1...8 {
            entryPointsLookup[Point(x: -1, y: n-1)] = n
        }
        for n in 9...16 {
            entryPointsLookup[Point(x: n-9, y: 8)] = n
        }
        for n in 17...24 {
            entryPointsLookup[Point(x: 8, y: 24-n)] = n
        }
        for n in 25...32 {
            entryPointsLookup[Point(x: 32-n, y: -1)] = n
        }
    }
    
    public func guess(entry: Int) -> Exit {
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
            return .None
        }
    }
    
    public func place(x: Int, y: Int) {
        println("adding (\(x),\(y))")
        balls[Point(x: x, y: y)] = true
    }
    
    func shoot(start: (x: Int, y: Int), direction startingDirection: Direction) -> Exit {
        var inBox = true
        var position = (x: start.x, y: start.y)
        var direction = startingDirection
        
        if willDetour((start.x, start.y), direction: direction) {
            return .Reflection
        }
        position = getNewPosition(position, direction: direction)
        while(inBox) {
            if willHit(position.x, y: position.y) {
                return .Hit
            }
            if willReflect((position.x, y: position.y), direction: direction) {
                return .Reflection
            }
            
            direction = getNewDirection((position.x, position.y), direction: direction)

            position = getNewPosition(position, direction: direction)
            inBox = !didExit(position)
        }
        return .Detour(entryPointsLookup[Point(x: position.x, y: position.y)]!)
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
    
    func willHit(x: Int, y: Int) -> Bool {
        return balls[Point(x: x, y: y)]!
    }
    
    func willDetour(position: (x: Int, y: Int), direction: Direction) -> Bool {
        let newDirection = getNewDirection((position.x, position.y), direction: direction)
        return newDirection != direction
    }
    
    func getNewDirection(position: (x: Int, y: Int), direction: Direction) -> Direction {
        switch direction {
        case .Up:
            if let leftBall = balls[Point(x: position.x - 1, y: position.y - 1)] {
                if leftBall {
                    return .Right
                }
            }
            if let rightBall = balls[Point(x: position.x + 1, y: position.y - 1)] {
                if rightBall {
                    return .Left
                }
            }
        case .Down:
            if let leftBall = balls[Point(x: position.x - 1, y: position.y + 1)] {
                if leftBall {
                    return .Right
                }
            }
            if let rightBall = balls[Point(x: position.x + 1, y: position.y + 1)] {
                if rightBall {
                    return .Left
                }
            }
        case .Left:
            if let topBall = balls[Point(x: position.x - 1, y: position.y - 1)] {
                if topBall {
                    return .Down
                }
            }
            if let bottomBall = balls[Point(x: position.x - 1, y: position.y + 1)] {
                if bottomBall {
                    return .Up
                }
            }
        case .Right:
            if let topBall = balls[Point(x: position.x + 1, y: position.y - 1)] {
                if topBall {
                    return .Down
                }
            }
            if let bottomBall = balls[Point(x: position.x + 1, y: position.y + 1)] {
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
            if let leftBall = balls[Point(x: position.x-1, y: position.y-1)] {
                if let rightBall = balls[Point(x: position.x+1, y: position.y-1)] {
                    return leftBall && rightBall
                }
            }
        case .Down:
            if let leftBall = balls[Point(x: position.x-1, y: position.y+1)] {
                if let rightBall = balls[Point(x: position.x+1, y: position.y+1)] {
                    return leftBall && rightBall
                }
            }
        case .Left:
            if let topBall = balls[Point(x: position.x-1, y: position.y-1)] {
                if let bottomBall = balls[Point(x: position.x-1, y: position.y+1)] {
                    return topBall && bottomBall
                }
            }
        case .Right:
            if let topBall = balls[Point(x: position.x+1, y: position.y-1)] {
                if let bottomBall = balls[Point(x: position.x+1, y: position.y+1)] {
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