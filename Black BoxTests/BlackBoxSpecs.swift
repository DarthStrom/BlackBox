import Black_Box

import Quick
import Nimble

class BlackBoxSpecs: QuickSpec {

    override func spec() {
        describe("custom game") {
            var game: Game!

            beforeEach {
                game = Game(size: 4)
            }

            it("initially has 0 probes") {
                expect(game.probes) == 0
            }

            describe("marking balls") {

                it("can mark a ball") {
                    game.markBallAt(column: 3, andRow: 4)
                    expect(game.marks).to(equal([Location(x: 3, y: 4): true]))
                }

                it("can remove a mark") {
                    game.markBallAt(column: 6, andRow: 5)
                    game.removeMarkAt(column: 6, andRow: 5)
                    expect(game.marks).to(beEmpty())
                }
            }

            // entry points are numbered 1...32 starting at the upper most left and
            // continuing counter-clockwise
            describe("probing") {

                func beAHit() -> NonNilMatcherFunc<ExitResult> {
                    return NonNilMatcherFunc { actualExpression, failureMessage in
                        failureMessage.postfixMessage = "be hit"
                        let actualResult = try actualExpression.evaluate()
                        switch actualResult {
                        case .some(.hit):
                            return true
                        default:
                            return false
                        }
                    }
                }

                func beAReflection() -> NonNilMatcherFunc<ExitResult> {
                    return NonNilMatcherFunc { actualExpression, failureMessage in
                        failureMessage.postfixMessage = "be reflection"
                        let actualResult = try actualExpression.evaluate()
                        switch actualResult {
                        case .some(.reflection):
                            return true
                        default:
                            return false
                        }
                    }
                }

                func beADetour(to i: Int) -> NonNilMatcherFunc<ExitResult> {
                    return NonNilMatcherFunc { actualExpression, failureMessage in
                        failureMessage.postfixMessage = "be detour(\(i))"
                        let actualResult = try actualExpression.evaluate()
                        switch actualResult {
                        case .some(.detour(i)):
                            return true
                        default:
                            return false
                        }
                    }
                }

                it("increments the guess count") {
                    let _ = game.probe(entry: 1)
                    expect(game.probes) == 1
                }

                it("increments again with another guess") {
                    let _ = game.probe(entry: 2)
                    let _ = game.probe(entry: 3)
                    expect(game.probes) == 2
                }

                describe("from the left") {

                    it("returns Hit when a ball is hit") {
                        game.placeAt(column: 0, andRow: 0)
                        expect(game.probe(entry: 1)).to(beAHit())                    }

                    it("exits the other side when no ball is hit") {
                        expect(game.probe(entry: 7)).to(beADetour(to: 18))
                    }

                    it("returns Reflection when ball prevents entering the box") {
                        game.placeAt(column: 0, andRow: 0)
                        expect(game.probe(entry: 2)).to(beAReflection())
                    }

                    it("returns Reflection when deflected by two balls at once") {
                        game.placeAt(column: 1, andRow: 1)
                        game.placeAt(column: 1, andRow: 3)
                        expect(game.probe(entry: 3)).to(beAReflection())
                    }

                    it("returns Detour when deflected") {
                        game.placeAt(column: 1, andRow: 1)
                        expect(game.probe(entry: 1)).to(beADetour(to: 32))
                    }
                }

                describe("from the bottom") {

                    it("returns Hit when a ball is hit") {
                        game.placeAt(column: 0, andRow: 0)
                        expect(game.probe(entry: 9)).to(beAHit())
                    }

                    it("exits the other side when no ball is hit") {
                        expect(game.probe(entry: 11)).to(beADetour(to: 30))
                    }

                    it("returns Reflection when ball prevents entering the box") {
                        game.placeAt(column: 4, andRow: 7)
                        expect(game.probe(entry: 14)).to(beAReflection())
                    }

                    it("returns Reflection when deflected by two balls at once") {
                        game.placeAt(column: 1, andRow: 1)
                        game.placeAt(column: 3, andRow: 1)
                        expect(game.probe(entry: 11)).to(beAReflection())
                    }

                    it("returns Detour when deflected") {
                        game.placeAt(column: 4, andRow: 3)
                        expect(game.probe(entry: 12)).to(beADetour(to: 5))
                    }
                }

                describe("from the right") {

                    it("returns Hit when a ball is hit") {
                        game.placeAt(column: 0, andRow: 7)
                        expect(game.probe(entry: 17)).to(beAHit())
                    }

                    it("exits the other side when no ball is hit") {
                        expect(game.probe(entry: 18)).to(beADetour(to: 7))
                    }

                    it("returns Reflection when ball prevents entering the box") {
                        game.placeAt(column: 7, andRow: 7)
                        expect(game.probe(entry: 18)).to(beAReflection())
                    }

                    it("returns Reflection when deflected by two balls at once") {
                        game.placeAt(column: 1, andRow: 1)
                        game.placeAt(column: 1, andRow: 3)
                        expect(game.probe(entry: 22)).to(beAReflection())
                    }

                    it("returns Detour when deflected") {
                        game.placeAt(column: 4, andRow: 3)
                        expect(game.probe(entry: 20)).to(beADetour(to:  14))
                    }
                }

                describe("from the top") {

                    it("returns Hit when a ball is hit") {
                        game.placeAt(column: 4, andRow: 3)
                        expect(game.probe(entry: 28)).to(beAHit())
                    }

                    it("exits the other side when no ball is hit") {
                        expect(game.probe(entry: 29)).to(beADetour(to: 12))
                    }

                    it("returns Reflection when ball prevents entering the box") {
                        game.placeAt(column: 0, andRow: 0)
                        expect(game.probe(entry: 31)).to(beAReflection())
                    }

                    it("returns Reflection when deflected by two balls at once") {
                        game.placeAt(column: 1, andRow: 1)
                        game.placeAt(column: 3, andRow: 1)
                        expect(game.probe(entry: 30)).to(beAReflection())
                    }

                    it("returns Detour when deflected") {
                        game.placeAt(column: 6, andRow: 3)
                        expect(game.probe(entry: 27)).to(beADetour(to: 3))
                    }
                }

                describe("multiple detours") {

                    it("can detour multiple times") {
                        game.placeAt(column: 4, andRow: 3)
                        game.placeAt(column: 7, andRow: 3)
                        expect(game.probe(entry: 14)).to(beADetour(to: 15))
                    }

                    it("will hit instead of reflecting on three balls in a row") {
                        game.placeAt(column: 4, andRow: 3)
                        game.placeAt(column: 5, andRow: 3)
                        game.placeAt(column: 6, andRow: 3)
                        expect(game.probe(entry: 14)).to(beAHit())
                    }

                    it("can detour many times") {
                        game.placeAt(column: 4, andRow: 0)
                        game.placeAt(column: 0, andRow: 2)
                        game.placeAt(column: 4, andRow: 4)
                        expect(game.probe(entry: 31)).to(beADetour(to: 10))
                    }

                    it("can reflect after detours") {
                        game.placeAt(column: 4, andRow: 0)
                        game.placeAt(column: 4, andRow: 4)
                        game.placeAt(column: 6, andRow: 4)
                        expect(game.probe(entry: 23)).to(beAReflection())
                    }

                    it("can hit after detours") {
                        game.placeAt(column: 0, andRow: 2)
                        game.placeAt(column: 7, andRow: 2)
                        game.placeAt(column: 5, andRow: 5)
                        game.placeAt(column: 6, andRow: 5)
                        game.placeAt(column: 0, andRow: 7)
                        expect(game.probe(entry: 13)).to(beAHit())
                    }

                    it("can reflect after many detours") {
                        game.placeAt(column: 0, andRow: 0)
                        game.placeAt(column: 6, andRow: 0)
                        game.placeAt(column: 6, andRow: 2)
                        game.placeAt(column: 0, andRow: 4)
                        game.placeAt(column: 6, andRow: 6)
                        expect(game.probe(entry: 10)).to(beAReflection())
                    }
                }

                describe("hit takes precedence") {
                    it("before entering box") {
                        game.placeAt(column: 0, andRow: 0)
                        game.placeAt(column: 0, andRow: 1)
                        expect(game.probe(entry: 1)).to(beAHit())
                    }
                }
            }

            describe("scoring") {

                it("counts rays as 1") {
                    let _ = game.probe(entry: 7)
                    expect(game.getScore()) == 1
                }

                it("counts multiple rays") {
                    let _ = game.probe(entry: 7)
                    let _ = game.probe(entry: 9)
                    let _ = game.probe(entry: 23)
                    let _ = game.probe(entry: 30)
                    expect(game.getScore()) == 4
                }

                it("counts wrong ball placement as 5") {
                    game.placeAt(column: 0, andRow: 0)
                    game.markBallAt(column: 1, andRow: 0)
                    expect(game.getScore()) == 5
                }

                it("counts correct ball placement as 0") {
                    game.placeAt(column: 2, andRow: 2)
                    game.markBallAt(column: 2, andRow: 2)
                    expect(game.getScore()) == 0
                }

                it("is finishable after 4 ball placements") {
                    game.markBallAt(column: 1, andRow: 1)
                    game.markBallAt(column: 2, andRow: 2)
                    game.markBallAt(column: 3, andRow: 3)
                    game.markBallAt(column: 4, andRow: 4)
                    expect(game.isFinishable()).to(beTrue())
                }

                it("is not finishable before 4 ball placements") {
                    game.markBallAt(column: 1, andRow: 1)
                    game.markBallAt(column: 2, andRow: 2)
                    game.markBallAt(column: 3, andRow: 3)
                    expect(game.isFinishable()).to(beFalse())
                }
            }

            describe("incorrect balls") {

                it("returns balls that were incorrectly marked") {
                    game.markBallAt(column: 5, andRow: 4)
                    expect(game.incorrectBalls()).to(contain(Location(x: 5, y: 4)))
                }

                it("does not return balls that were correctly marked") {
                    game.placeAt(column: 4, andRow: 5)
                    game.markBallAt(column: 4, andRow: 5)
                    expect(game.incorrectBalls()).to(beEmpty())
                }
            }

            describe("missed balls") {

                it("returns balls that were not marked") {
                    game.placeAt(column: 6, andRow: 3)
                    expect(game.missedBalls()).to(contain(Location(x: 6, y: 3)))
                }

                it("does not return balls that were correctly marked") {
                    game.placeAt(column: 2, andRow: 7)
                    game.markBallAt(column: 2, andRow: 7)
                    expect(game.missedBalls()).to(beEmpty())
                }
            }

            describe("correct balls") {

                it("returns balls that were marked correctly") {
                    game.placeAt(column: 5, andRow: 5)
                    game.markBallAt(column: 5, andRow: 5)
                    expect(game.correctBalls()).to(contain(Location(x: 5, y: 5)))
                }

                it("does not return balls that were marked incorrectly") {
                    game.placeAt(column: 2, andRow: 3)
                    game.markBallAt(column: 3, andRow: 3)
                    expect(game.correctBalls()).to(beEmpty())
                }
            }
        }

        describe("defined game") {
            it("can be initialized with ball placement") {
                let balls = [Location(x: 4, y: 6),
                    Location(x: 2, y: 2),
                    Location(x: 1, y: 1),
                    Location(x: 7, y: 2)]
                let game = Game(balls: balls)

                game.markBallAt(column: 1, andRow: 1)
                game.markBallAt(column: 2, andRow: 2)
                game.markBallAt(column: 3, andRow: 3)
                game.markBallAt(column: 4, andRow: 4)

                expect(game.size) == 4
                expect(game.correctBalls()).to(contain(Location(x: 1, y: 1)))
                expect(game.correctBalls()).to(contain(Location(x: 2, y: 2)))
                expect(game.incorrectBalls()).to(contain(Location(x: 3, y: 3)))
                expect(game.incorrectBalls()).to(contain(Location(x: 4, y: 4)))
                expect(game.missedBalls()).to(contain(Location(x: 4, y: 6)))
                expect(game.missedBalls()).to(contain(Location(x: 7, y: 2)))
            }
        }
    }

}
