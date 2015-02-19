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
        
        let ray = Ray(entry: entry, board: board)
        return ray.shoot()
    }
    
    public func placeAtColumn(column: Int, andRow row: Int) {
        board.placeAtColumn(column, andRow: row)
    }
}