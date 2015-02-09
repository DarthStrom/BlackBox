//
//  BlackBoxSpecs.swift
//  Black Box
//
//  Created by Jason Duffy on 12/29/14.
//  Copyright (c) 2014 Peapod Media, llc. All rights reserved.
//

import Black_Box

import Quick
import Nimble

class BlackBoxSpecs: QuickSpec {

    override func spec() {
        describe("game") {
            var game: Game?
            beforeEach {
                game = Game()
            }
        
            it("initially has 0 guesses") {
                expect(game!.guesses) == 0
            }
            
            // entry points are numbered 1...32 starting at the upper most left and
            // continuing counter-clockwise
            describe("guessing") {
                let expectHit = { (entryPoint: Int) -> () in
                    switch game!.guess(entryPoint) {
                    case .Hit:
                        expect(true)
                    case .Miss:
                        fail("Expected a Hit but got a Miss")
                    case .Reflection:
                        fail("Expected a Hit but got a reflection")
                    case .Detour(let i):
                        fail("Expected a Hit but got a Detour to \(i)")
                    }
                }
                
                let expectMiss = { (entryPoint: Int, exitPoint: Int) -> () in
                    switch game!.guess(entryPoint) {
                    case .Hit:
                        fail("Expected a Miss but got a Hit")
                    case .Miss(let i):
                        expect(exitPoint == i)
                    case .Reflection:
                        fail("Expected a Miss but got a Reflection")
                    case .Detour(let i):
                        fail("Expected a Hit but got a Detour to \(i)")
                    }
                }
                
                let expectReflection = { (entryPoint: Int) -> () in
                    switch game!.guess(entryPoint) {
                    case .Hit:
                        fail("Expected a Reflection but got a Hit")
                    case .Miss(_):
                        fail("Expected a Reflection but got a Miss")
                    case .Reflection:
                        expect(true)
                    case .Detour(let i):
                        fail("Expected a Reflection but got a Detour to \(i)")
                    }
                }
                
                it("increments the guess count") {
                    game!.guess(1)
                    expect(game!.guesses) == 1
                }
                
                it("increments again with another guess") {
                    game!.guess(2)
                    game!.guess(3)
                    expect(game!.guesses) == 2
                }
                
                describe("from the left") {
                    
                    it("returns Hit when a ball is hit") {
                        game!.place(0, y: 0)
                        expectHit(1)
                    }
                    
                    it("returns Miss when no ball is hit") {
                        expectMiss(7, 18)
                    }
                    
                    it("returns Reflection when ball prevents entering the box") {
                        game!.place(0, y: 0)
                        expectReflection(2)
                    }
                    
                    it("returns Reflection when deflected by two balls at once") {
                        game!.place(1, y: 1)
                        game!.place(1, y: 3)
                        expectReflection(3)
                    }
                }
                
                describe("from the bottom") {
                    
                    it("returns Hit when a ball is hit") {
                        game!.place(0, y: 0)
                        expectHit(9)
                    }
                    
                    it("returns Miss when no ball is hit") {
                        expectMiss(11, 30)
                    }
                    
                    it("returns Reflection when ball prevents entering the box") {
                        game!.place(4, y: 7)
                        expectReflection(14)
                    }
                    
                    it("returns Reflection when deflected by two balls at once") {
                        game!.place(1, y: 1)
                        game!.place(3, y: 1)
                        expectReflection(11)
                    }
                }
                
                describe("from the right") {
                    
                    it("returns Hit when a ball is hit") {
                        game!.place(0, y: 7)
                        expectHit(17)
                    }
                    
                    it("returns Miss when no ball is hit") {
                        expectMiss(18, 7)
                    }
                    
                    it("returns Reflection when ball prevents entering the box") {
                        game!.place(7, y: 7)
                        expectReflection(18)
                    }
                    
                    it("returns Reflection when deflected by two balls at once") {
                        game!.place(1, y: 1)
                        game!.place(1, y: 3)
                        expectReflection(22)
                    }
                }
                
                describe("from the top") {
                    
                    it("returns Hit when a ball is hit") {
                        game!.place(4, y: 3)
                        expectHit(28)
                    }
                    
                    it("returns Miss when no ball is hit") {
                        expectMiss(29, 12)
                    }
                    
                    it("returns Reflection when ball prevents entering the box") {
                        game!.place(7, y: 1)
                        expectReflection(24)
                    }
                    
                    it("returns Reflection when deflected by two balls at once") {
                        game!.place(1, y: 1)
                        game!.place(3, y: 1)
                        expectReflection(30)
                    }
                }
            }
        }
    }
}