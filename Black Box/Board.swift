//
//  Board.swift
//  Black Box
//
//  Created by Jason Duffy on 2/18/15.
//  Copyright (c) 2015 Peapod Media, llc. All rights reserved.
//

class Board {
    var slots = [Location: Bool]()
    var entries = [Location: Int]()
    
    init () {
        clearSlots()
        populateEntries()
    }
    
    func clearSlots() {
        for y in 0...7 {
            for x in 0...7 {
                slots[Location(x: x, y: y)] = false
            }
        }
    }
    
    func populateEntries() {
        for n in 1...8 {
            entries[Location(x: -1, y: n-1)] = n
        }
        for n in 9...16 {
            entries[Location(x: n-9, y: 8)] = n
        }
        for n in 17...24 {
            entries[Location(x: 8, y: 24-n)] = n
        }
        for n in 25...32 {
            entries[Location(x: 32-n, y: -1)] = n
        }
    }
    
    func place(x: Int, y: Int) {
       slots[Location(x: x, y: y)] = true
    }
    
    func getExitPoint(x: Int, y: Int) -> Int? {
        return entries[Location(x: x, y: y)]
    }
    
    func getSlot(x: Int, y: Int) -> Bool? {
        return slots[Location(x: x, y: y)]
    }
}