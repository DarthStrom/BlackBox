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

        XCTAssertTrue(subject.isFinishable)
    }

    func testIsNotFinishableIfGameIsNotFinishable() {
        mockGame.finished = false

        XCTAssertFalse(subject.isFinishable)
    }

    func testIsNotFinishableIfThereIsNoGame() {
        subject.game = nil

        XCTAssertFalse(subject.isFinishable)
    }

    func testGetsProbesFromTheGame() {
        mockGame.setProbes(5)

        XCTAssertEqual("5", subject.probes)
    }

    func testReportsNoGameWhenGameDoesNotExist() {
        subject.game = nil

        XCTAssertEqual("No game", subject.probes)
        XCTAssertEqual("No game", subject.incorrectBalls)
        XCTAssertEqual("No game", subject.score)
    }

    func testGetsIncorrectBallsScore() {
        mockGame.incorrect = 4

        XCTAssertEqual(String(4*5), subject.incorrectBalls)
    }

    func testIncorrectBallsScoresZero() {
        mockGame.incorrect = 0

        XCTAssertEqual("0", subject.incorrectBalls)
    }

    func testGetsParFromLevel() {
        mockLevel.setPar(4)

        XCTAssertEqual(4, subject.par)
    }

    func testGetsScoreFromGame() {
        mockGame.mockScore = 27

        XCTAssertEqual("27", subject.score)
    }

    func testTryingToAddAnEntryPointAbove32DoesNotAddAChild() {
        XCTAssertEqual(96, subject.children.count)

        subject.addEntryPoint(number: 33)

        XCTAssertEqual(96, subject.children.count)
    }

    func testShootingBeforeThereIsAGameHidesEntryPoint() {
        subject.game = nil

        shootSlot(number: 1)

        XCTAssertTrue(subject.entryPoints[1]!.isHidden)
    }

    func testShootSlot1() {
        mockGame.probeWill(.hit)

        shootSlot(number: 1)

        let entryPoint = subject.entryPoints[1]
        XCTAssertEqual("<SKTexture> \'Hit\' (148 x 148)", entryPoint?.texture?.description)
        XCTAssertFalse(subject.entryPoints[1]!.isHidden)
    }

    func testShootSlot2() {
        mockGame.probeWill(.detour(1))

        shootSlot(number: 2)

        let entryPoint1 = subject.entryPoints[1]
        let entryPoint2 = subject.entryPoints[2]
        XCTAssertEqual("<SKTexture> \'Detour1\' (148 x 148)", entryPoint1?.texture?.description)
        XCTAssertEqual("<SKTexture> \'Detour1\' (148 x 148)", entryPoint2?.texture?.description)
        XCTAssertEqual(1, subject.detours)
        XCTAssertFalse(entryPoint1!.isHidden)
        XCTAssertFalse(entryPoint2!.isHidden)
    }

    func testShootSlot3() {
        mockGame.probeWill(.reflection)

        shootSlot(number: 3)

        let entryPoint = subject.entryPoints[3]
        XCTAssertEqual("<SKTexture> \'Reflection\' (148 x 148)", entryPoint?.texture?.description)
        XCTAssertFalse(entryPoint!.isHidden)
    }

    func testShootSlot9() {
        shootSlot(number: 9)

        XCTAssertFalse(subject.entryPoints[9]!.isHidden)
    }

    func testShootSlot18() {
        shootSlot(number: 18)

        XCTAssertFalse(subject.entryPoints[18]!.isHidden)
    }

    func testShootSlot28() {
        shootSlot(number: 28)

        XCTAssertFalse(subject.entryPoints[28]!.isHidden)
    }

    func testShootSlot29() {
        shootSlot(number: 29)

        XCTAssertFalse(subject.entryPoints[29]!.isHidden)
    }

    func testShootSlot30() {
        shootSlot(number: 30)

        XCTAssertFalse(subject.entryPoints[30]!.isHidden)
    }

    func testDoesNothingWhenTouchingNoEntryPointsOrSlots() {
        subject.handleTouch(CGPoint(x: 1.0, y: 1.0))

        for entryPoint in subject.entryPoints {
            XCTAssertTrue(entryPoint.1.isHidden)
        }
        for slot in subject.slots {
            XCTAssertTrue(slot.1.isHidden)
        }
    }

    func testToggleSlot00() {
        touchSlot(column: 0, row: 0)

        XCTAssertFalse(subject.slots[0]!.isHidden)

        touchSlot(column: 0, row: 0)

        XCTAssertTrue(subject.slots[0]!.isHidden)
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


    func shootSlot(number: Int) {
        switch number {
        case 1...8:
            subject.handleTouch(CGPoint(x: subject.border + 1, y: subject.size.width - subject.border - subject.cellWidth * CGFloat(number) - 1))
        case 9...16:
            subject.handleTouch(CGPoint(x: subject.border + subject.cellWidth * CGFloat(number - 8) + 1, y: subject.border + 1))
        case 17...24:
            subject.handleTouch(CGPoint(x: subject.border + subject.cellWidth * 9 + 1, y: subject.border + subject.cellWidth * CGFloat(number - 16) + 1))
        case 25...32:
            subject.handleTouch(CGPoint(x: subject.border + subject.cellWidth * CGFloat(33 - number), y: subject.size.width - subject.border - 1))
        default: break
        }
    }

    func touchSlot(column: Int, row: Int) {
        subject.handleTouch(CGPoint(x: subject.border + subject.cellWidth * (CGFloat(column) + 1.0) + 1.0, y: subject.size.width - subject.border - subject.cellWidth * (CGFloat(row) + 1.0)))
    }

    class MockGame: Game {
        var finished = false
        var correct = 0
        var incorrect = 0
        var missed = 0
        var mockScore = 0
        var probe = ExitResult.hit

        override var isFinishable: Bool {
            return finished
        }

        override var incorrectBalls: [Location] {
            return populate(incorrect)
        }

        override var missedBalls: [Location] {
            return populate(missed)
        }

        override var correctBalls: [Location] {
            return populate(correct)
        }

        override var score: Int {
            return mockScore
        }

        override func probe(entry: Int) -> ExitResult? {
            return probe
        }

        func populate(_ count: Int) -> [Location] {
            var result = [Location]()
            for i in 0..<count {
                result.append(Location(x: i, y: i))
            }
            return result
        }

        func setProbes(_ probes: Int) {
            super.probes = probes
        }

        func probeWill(_ exitResult: ExitResult) {
            probe = exitResult
        }

    }

    class MockLevel: Level {

        func setPar(_ par: Int) {
            super.par = par
        }

    }
}
