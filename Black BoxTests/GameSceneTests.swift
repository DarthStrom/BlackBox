//
//  GameSceneTests.swift
//  Black Box
//
//  Created by Jason Duffy on 11/24/15.
//  Copyright © 2015 Peapod Multimedia, ltd. All rights reserved.
//

import XCTest
@testable import Black_Box

class GameSceneTests: XCTestCase {

    var subject: GameScene!
    var mockGame: MockGame!
    var mockLevel: MockLevel!

    override func setUp() {
        subject = GameScene(size: CGSize(width: 100, height: 100))
        mockGame = MockGame(size: 4)
        mockLevel = MockLevel(number: 1)
        subject.game = mockGame
        subject.level = mockLevel
    }
    
    func testIsFinishableIfGameIsFinishable() {
        mockGame.finished = true

        XCTAssertTrue(subject.isFinishable())
    }

    func testIsNotFinishableIfGameIsNotFinishable() {
        mockGame.finished = false

        XCTAssertFalse(subject.isFinishable())
    }

    func testIsNotFinishableIfThereIsNoGame() {
        subject.game = nil

        XCTAssertFalse(subject.isFinishable())
    }

    func testGetsProbesFromTheGame() {
        mockGame.setProbes(5)

        XCTAssertEqual("5", subject.getProbes())
    }

    func testReportsNoGameWhenGameDoesNotExist() {
        subject.game = nil

        XCTAssertEqual("No game", subject.getProbes())
        XCTAssertEqual("No game", subject.getIncorrectBalls())
        XCTAssertEqual("No game", subject.getScore())
    }

    func testGetsIncorrectBallsScore() {
        mockGame.incorrect = 4

        XCTAssertEqual(String(4*5), subject.getIncorrectBalls())
    }

    func testIncorrectBallsScoresZero() {
        mockGame.incorrect = 0

        XCTAssertEqual("0", subject.getIncorrectBalls())
    }

    func testGetsParFromLevel() {
        mockLevel.setPar(4)

        XCTAssertEqual(4, subject.getPar())
    }

    func testGetsScoreFromGame() {
        mockGame.score = 27

        XCTAssertEqual("27", subject.getScore())
    }

    func testTryingToAddAnEntryPointAbove32DoesNotAddAChild() {
        XCTAssertEqual(97, subject.children.count)

        subject.addEntryPoint(33)

        XCTAssertEqual(97, subject.children.count)
    }

    func testShootingBeforeThereIsAGameHidesEntryPoint() {
        subject.game = nil

        subject.handleTouch(CGPoint(x: 50.0, y: 650.0))

        XCTAssertTrue(subject.entryPoints[1]!.hidden)
    }

    func testShootSlot1() {
        mockGame.probeWill(.Hit)

        subject.handleTouch(CGPoint(x: 50.0, y: 650.0))

        let entryPoint = subject.entryPoints[1]
        XCTAssertEqual("<SKTexture> \'Hit\' (148 x 148)", entryPoint?.texture?.description)
        XCTAssertFalse(subject.entryPoints[1]!.hidden)
    }

    func testShootSlot2() {
        mockGame.probeWill(.Detour(1))

        subject.handleTouch(CGPoint(x: 50.0, y: 600.0))

        let entryPoint1 = subject.entryPoints[1]
        let entryPoint2 = subject.entryPoints[2]
        XCTAssertEqual("<SKTexture> \'Detour1\' (148 x 148)", entryPoint1?.texture?.description)
        XCTAssertEqual("<SKTexture> \'Detour1\' (148 x 148)", entryPoint2?.texture?.description)
        XCTAssertEqual(1, subject.detours)
        XCTAssertFalse(entryPoint1!.hidden)
        XCTAssertFalse(entryPoint2!.hidden)
    }

    func testShootSlot3() {
        mockGame.probeWill(.Reflection)

        subject.handleTouch(CGPoint(x: 50.0, y: 500.0))

        let entryPoint = subject.entryPoints[3]
        XCTAssertEqual("<SKTexture> \'Reflection\' (148 x 148)", entryPoint?.texture?.description)
        XCTAssertFalse(entryPoint!.hidden)
    }

    func testShootSlot9() {
        subject.handleTouch(CGPoint(x: 100.0, y: 50.0))

        XCTAssertFalse(subject.entryPoints[9]!.hidden)
    }

    func testShootSlot18() {
        subject.handleTouch(CGPoint(x: 700.0, y: 200.0))

        XCTAssertFalse(subject.entryPoints[18]!.hidden)
    }

    func testShootSlot28() {
        subject.handleTouch(CGPoint(x: 400.0, y: 700.0))

        XCTAssertFalse(subject.entryPoints[28]!.hidden)
    }

    func testShootSlot29() {
        subject.handleTouch(CGPoint(x: 350.0, y: 700.0))

        XCTAssertFalse(subject.entryPoints[29]!.hidden)
    }

    func testShootSlot30() {
        subject.handleTouch(CGPoint(x: 300.0, y: 700.0))

        XCTAssertFalse(subject.entryPoints[30]!.hidden)
    }

    func testDoesNothingWhenTouchingNoEntryPointsOrSlots() {
        subject.handleTouch(CGPoint(x: 1.0, y: 1.0))

        for entryPoint in subject.entryPoints {
            XCTAssertTrue(entryPoint.1.hidden)
        }
        for slot in subject.slots {
            XCTAssertTrue(slot.1.hidden)
        }
    }

    func testToggleSlot00() {
        subject.handleTouch(CGPoint(x: 120.0, y: 645.0))

        XCTAssertFalse(subject.slots[0]!.hidden)

        subject.handleTouch(CGPoint(x: 120.0, y: 645.0))

        XCTAssertTrue(subject.slots[0]!.hidden)
    }

    func testCanShowIncorrectBalls() {
        mockGame.incorrect = 1

        subject.showIncorrectBalls()

        XCTAssertEqual("<SKTexture> \'Incorrect\' (148 x 148)", subject.slots[0]?.texture?.description)
    }

    func testCanShowMissedBalls() {
        mockGame.missed = 1

        subject.showMissedBalls()

        XCTAssertEqual("<SKTexture> \'Miss\' (148 x 148)", subject.slots[0]?.texture?.description)
    }

    func testCanShowCorrectBalls() {
        mockGame.correct = 1

        subject.showCorrectBalls()

        XCTAssertEqual("<SKTexture> \'Correct\' (148 x 148)", subject.slots[0]?.texture?.description)
    }

    class MockGame: Game {
        var finished = false
        var correct = 0
        var incorrect = 0
        var missed = 0
        var score = 0
        var probe = ExitResult.Hit

        override func isFinishable() -> Bool {
            return finished
        }

        override func incorrectBalls() -> [Location] {
            return populate(incorrect)
        }

        override func missedBalls() -> [Location] {
            return populate(missed)
        }

        override func correctBalls() -> [Location] {
            return populate(correct)
        }

        override func getScore() -> Int {
            return score
        }

        override func probe(entry: Int) -> ExitResult? {
            return probe
        }

        func populate(count: Int) -> [Location] {
            var result = [Location]()
            for i in 0..<count {
                result.append(Location(x: i, y: i))
            }
            return result
        }

        func setProbes(probes: Int) {
            super.probes = probes
        }

        func probeWill(exitResult: ExitResult) {
            probe = exitResult
        }
    }

    class MockLevel: Level {
        func setPar(par: Int) {
            super.par = par
        }
    }
}
