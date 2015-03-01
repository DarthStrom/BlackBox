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
      
      describe("marking balls") {
        
        it("can mark a ball") {
          game!.markBallAtColumn(3, andRow: 4)
          expect(game!.marks).to(equal([Location(x: 3, y: 4): true]))
        }
        
        it("can remove a mark") {
          game!.markBallAtColumn(6, andRow: 5)
          game!.removeMarkAtColumn(6, andRow: 5)
          expect(game!.marks).to(beEmpty())
        }
      }
      
      // entry points are numbered 1...32 starting at the upper most left and
      // continuing counter-clockwise
      describe("guessing") {
        let expectHit = { (entryPoint: Int) -> () in
          switch game!.guess(entryPoint) {
          case .Some(.Hit):
            expect(true)
          case .Some(.Reflection):
            fail("Expected a Hit but got a Reflection")
          case .Some(.Detour(let i)):
            fail("Expected a Hit but got a Detour to \(i)")
          case .None:
            fail("Invalid entry")
          }
        }
        
        let expectReflection = { (entryPoint: Int) -> () in
          switch game!.guess(entryPoint) {
          case .Some(.Hit):
            fail("Expected a Reflection but got a Hit")
          case .Some(.Reflection):
            expect(true)
          case .Some(.Detour(let i)):
            fail("Expected a Reflection but got a Detour to \(i)")
          case .None:
            fail("Invalid entry")
          }
        }
        
        let expectDetour = { (entryPoint: Int, exitPoint: Int) -> () in
          switch game!.guess(entryPoint) {
          case .Some(.Hit):
            fail("Expected a Detour but got a Hit")
          case .Some(.Reflection):
            fail("Expected a Detour but got a Reflection")
          case .Some(.Detour(let i)):
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
            game!.placeAtColumn(0, andRow: 0)
            expectHit(1)
          }
          
          it("exits the other side when no ball is hit") {
            expectDetour(7, 18)
          }
          
          it("returns Reflection when ball prevents entering the box") {
            game!.placeAtColumn(0, andRow: 0)
            expectReflection(2)
          }
          
          it("returns Reflection when deflected by two balls at once") {
            game!.placeAtColumn(1, andRow: 1)
            game!.placeAtColumn(1, andRow: 3)
            expectReflection(3)
          }
          
          it("returns Detour when deflected") {
            game!.placeAtColumn(1, andRow: 1)
            expectDetour(1, 32)
          }
        }
        
        describe("from the bottom") {
          
          it("returns Hit when a ball is hit") {
            game!.placeAtColumn(0, andRow: 0)
            expectHit(9)
          }
          
          it("exits the other side when no ball is hit") {
            expectDetour(11, 30)
          }
          
          it("returns Reflection when ball prevents entering the box") {
            game!.placeAtColumn(4, andRow: 7)
            expectReflection(14)
          }
          
          it("returns Reflection when deflected by two balls at once") {
            game!.placeAtColumn(1, andRow: 1)
            game!.placeAtColumn(3, andRow: 1)
            expectReflection(11)
          }
          
          it("returns Detour when deflected") {
            game!.placeAtColumn(4, andRow: 3)
            expectDetour(12, 5)
          }
        }
        
        describe("from the right") {
          
          it("returns Hit when a ball is hit") {
            game!.placeAtColumn(0, andRow: 7)
            expectHit(17)
          }
          
          it("exits the other side when no ball is hit") {
            expectDetour(18, 7)
          }
          
          it("returns Reflection when ball prevents entering the box") {
            game!.placeAtColumn(7, andRow: 7)
            expectReflection(18)
          }
          
          it("returns Reflection when deflected by two balls at once") {
            game!.placeAtColumn(1, andRow: 1)
            game!.placeAtColumn(1, andRow: 3)
            expectReflection(22)
          }
          
          it("returns Detour when deflected") {
            game!.placeAtColumn(4, andRow: 3)
            expectDetour(20, 14)
          }
        }
        
        describe("from the top") {
          
          it("returns Hit when a ball is hit") {
            game!.placeAtColumn(4, andRow: 3)
            expectHit(28)
          }
          
          it("exits the other side when no ball is hit") {
            expectDetour(29, 12)
          }
          
          it("returns Reflection when ball prevents entering the box") {
            game!.placeAtColumn(0, andRow: 0)
            expectReflection(31)
          }
          
          it("returns Reflection when deflected by two balls at once") {
            game!.placeAtColumn(1, andRow: 1)
            game!.placeAtColumn(3, andRow: 1)
            expectReflection(30)
          }
          
          it("returns Detour when deflected") {
            game!.placeAtColumn(6, andRow: 3)
            expectDetour(27, 3)
          }
        }
        
        describe("multiple detours") {
          
          it("can detour multiple times") {
            game!.placeAtColumn(4, andRow: 3)
            game!.placeAtColumn(7, andRow: 3)
            expectDetour(14, 15)
          }
          
          it("will hit instead of reflecting on three balls in a row") {
            game!.placeAtColumn(4, andRow: 3)
            game!.placeAtColumn(5, andRow: 3)
            game!.placeAtColumn(6, andRow: 3)
            expectHit(14)
          }
          
          it("can detour many times") {
            game!.placeAtColumn(4, andRow: 0)
            game!.placeAtColumn(0, andRow: 2)
            game!.placeAtColumn(4, andRow: 4)
            expectDetour(31, 10)
          }
          
          it("can reflect after detours") {
            game!.placeAtColumn(4, andRow: 0)
            game!.placeAtColumn(4, andRow: 4)
            game!.placeAtColumn(6, andRow: 4)
            expectReflection(23)
          }
          
          it("can hit after detours") {
            game!.placeAtColumn(0, andRow: 2)
            game!.placeAtColumn(7, andRow: 2)
            game!.placeAtColumn(5, andRow: 5)
            game!.placeAtColumn(6, andRow: 5)
            game!.placeAtColumn(0, andRow: 7)
            expectHit(13)
          }
          
          it("can reflect after many detours") {
            game!.placeAtColumn(0, andRow: 0)
            game!.placeAtColumn(6, andRow: 0)
            game!.placeAtColumn(6, andRow: 2)
            game!.placeAtColumn(0, andRow: 4)
            game!.placeAtColumn(6, andRow: 6)
            expectReflection(10)
          }
        }
      }
    }
  }
}