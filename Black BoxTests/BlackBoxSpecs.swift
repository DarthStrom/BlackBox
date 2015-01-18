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
                expect(game!.guesses).to(equal(0))
            }
            
            // spots on board are numbered 0...63 starting at the top left
            // entry points are numbered 1...32 starting at the upper most left and continuing counter-clockwise
            describe("guessing") {
                it("increments the guess count") {
                    game!.guess(1)
                    expect(game!.guesses).to(equal(1))
                }
                
                it("increments again with another guess") {
                    game!.guess(2)
                    game!.guess(3)
                    expect(game!.guesses).to(equal(2))
                }
                
                it("returns Hit when a ball is hit") {
                    game!.place(0)
                    switch game!.guess(1) {
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
                
                it("returns Miss when no ball is hit") {
                    switch game!.guess(1) {
                    case .Hit:
                        fail("Expected a Miss but got a Hit")
                    case .Miss:
                        expect(true)
                    case .Reflection:
                        fail("Expected a Miss but got a Reflection")
                    case .Detour(let i):
                        fail("Expected a Hit but got a Detour to \(i)")
                    }
                }
                
//                it("returns Reflection when deflection prevents entering the box") {
//                    game!.place(60)
//                    switch game!.guess(14) {
//                    case .Hit:
//                        fail("Expected a Reflection but got a Hit")
//                    case .Miss:
//                        fail("Expected a Reflection but got a Miss")
//                    case .Reflection:
//                        expect(true)
//                    case .Detour(let i):
//                        fail("Expected a Reflection but got a Detour to \(i)")
//                    }
//                }
            }
        }
    }
}