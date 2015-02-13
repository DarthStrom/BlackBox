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
                    case .Reflection:
                        fail("Expected a Hit but got a Reflection")
                    case .Detour(let i):
                        fail("Expected a Hit but got a Detour to \(i)")
                    case .None:
                        fail("Invalid entry")
                    }
                }
                
                let expectReflection = { (entryPoint: Int) -> () in
                    switch game!.guess(entryPoint) {
                    case .Hit:
                        fail("Expected a Reflection but got a Hit")
                    case .Reflection:
                        expect(true)
                    case .Detour(let i):
                        fail("Expected a Reflection but got a Detour to \(i)")
                    case .None:
                        fail("Invalid entry")
                    }
                }
                
                let expectDetour = { (entryPoint: Int, exitPoint: Int) -> () in
                    switch game!.guess(entryPoint) {
                    case .Hit:
                        fail("Expected a Detour but got a Hit")
                    case .Reflection:
                        fail("Expected a Detour but got a Reflection")
                    case .Detour(let i):
                        expect(i).to(equal(exitPoint))
                    case .None:
                        fail("Invalid entry")
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
                    
                    it("exits the other side when no ball is hit") {
                        expectDetour(7, 18)
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
                    
                    it("returns Detour when deflected") {
                        game!.place(1, y: 1)
                        expectDetour(1, 32)
                    }
                }
                
                describe("from the bottom") {
                    
                    it("returns Hit when a ball is hit") {
                        game!.place(0, y: 0)
                        expectHit(9)
                    }
                    
                    it("exits the other side when no ball is hit") {
                        expectDetour(11, 30)
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
                    
                    it("returns Detour when deflected") {
                        game!.place(4, y: 3)
                        expectDetour(12, 5)
                    }
                }
                
                describe("from the right") {
                    
                    it("returns Hit when a ball is hit") {
                        game!.place(0, y: 7)
                        expectHit(17)
                    }
                    
                    it("exits the other side when no ball is hit") {
                        expectDetour(18, 7)
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
                    
                    it("returns Detour when deflected") {
                        game!.place(4, y: 3)
                        expectDetour(20, 14)
                    }
                }
                
                describe("from the top") {
                    
                    it("returns Hit when a ball is hit") {
                        game!.place(4, y: 3)
                        expectHit(28)
                    }
                    
                    it("exits the other side when no ball is hit") {
                        expectDetour(29, 12)
                    }
                    
                    it("returns Reflection when ball prevents entering the box") {
                        game!.place(0, y: 0)
                        expectReflection(31)
                    }
                    
                    it("returns Reflection when deflected by two balls at once") {
                        game!.place(1, y: 1)
                        game!.place(3, y: 1)
                        expectReflection(30)
                    }
                    
                    it("returns Detour when deflected") {
                        game!.place(6, y: 3)
                        expectDetour(27, 3)
                    }
                }
                
                describe("multiple detours") {
                    
                    it("can detour multiple times") {
                        game!.place(4, y: 3)
                        game!.place(7, y: 3)
                        expectDetour(14, 15)
                    }
                    
                    it("will hit instead of reflecting on three balls in a row") {
                        game!.place(4, y: 3)
                        game!.place(5, y: 3)
                        game!.place(6, y: 3)
                        expectHit(14)
                    }
                    
                    it("can detour many times") {
                        game!.place(4, y: 0)
                        game!.place(0, y: 2)
                        game!.place(4, y: 4)
                        expectDetour(31, 10)
                    }
                    
                    it("can reflect after detours") {
                        game!.place(4, y: 0)
                        game!.place(4, y: 4)
                        game!.place(6, y: 4)
                        expectReflection(23)
                    }
                    
                    it("can hit after detours") {
                        game!.place(0, y: 2)
                        game!.place(7, y: 2)
                        game!.place(5, y: 5)
                        game!.place(6, y: 5)
                        game!.place(0, y: 7)
                        expectHit(13)
                    }
                    
                    it("can reflect after many detours") {
                        game!.place(0, y: 0)
                        game!.place(6, y: 0)
                        game!.place(6, y: 2)
                        game!.place(0, y: 4)
                        game!.place(6, y: 6)
                        expectReflection(10)
                    }
                }
            }
        }
    }
}