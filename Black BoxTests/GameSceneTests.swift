//
//  GameSceneTests.swift
//  Black Box
//
//  Created by Jason Duffy on 11/24/15.
//  Copyright © 2015 Peapod Multimedia, ltd. All rights reserved.
//

import XCTest
import Moxie
@testable import Black_Box

class GameSceneTests: XCTestCase {

    var subject: GameScene!
    var mockGame: MockGame!
    var mockLevel: MockLevel!

    override func setUp() {
        subject = GameScene(size: CGSize(width: 100, height: 100))
        mockGame = MockGame()
        mockLevel = MockLevel()
        subject.game = mockGame
        subject.level = mockLevel
    }

    func testIsFinishableIfGameIsFinishable() {
        mockGame.stub(function: "isFinishable", return: true)

        XCTAssertTrue(subject.isFinishable)
    }

    func testIsNotFinishableIfGameIsNotFinishable() {
        mockGame.stub(function: "isFinishable", return: false)

        XCTAssertFalse(subject.isFinishable)
    }

    func testGetsProbesFromTheGame() {
        mockGame.probes = 5

        XCTAssertEqual("5", subject.probes)
    }

    func testGetsIncorrectBallsScore() {
        let balls: [Location] = [Location(1,1), Location(2,2), Location(3,3), Location(4,4)]
        mockGame.stub(function: "incorrectBalls", return: balls)

        XCTAssertEqual(String(4*5), subject.incorrectBalls)
    }

    func testIncorrectBallsScoresZero() {
        mockGame.stub(function: "incorrectBalls", return: 0)

        XCTAssertEqual("0", subject.incorrectBalls)
    }

    func testGetsParFromLevel() {
        mockLevel.stub(function: "par", return: 4)

        XCTAssertEqual(4, subject.par)
    }

    func testGetsScoreFromGame() {
        mockGame.stub(function: "score", return: 27)

        XCTAssertEqual("27", subject.score)
    }

    func testTryingToAddAnEntryPointAbove32DoesNotAddAChild() {
        XCTAssertEqual(96, subject.children.count)

        subject.addEntryPoint(number: 33)

        XCTAssertEqual(96, subject.children.count)
    }

    func testShootSlot1() {
        mockGame.stub(function: "probe", return: ExitResult.hit)

        shootSlot(number: 1)

        let entryPoint = subject.entryPoints[1]
        XCTAssertEqual("<SKTexture> \'Hit\' (148 x 148)", entryPoint?.texture?.description)
        XCTAssertFalse(subject.entryPoints[1]!.isHidden)
    }

    func testShootSlot2() {
        mockGame.stub(function: "probe", return: ExitResult.detour(1))

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
        mockGame.stub(function: "probe", return: ExitResult.reflection)

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
        let incorrect = [Location(0, 0)]
        mockGame.stub(function: "incorrectBalls", return: incorrect)

        subject.showIncorrectBalls()

        XCTAssertEqual("<SKTexture> \'Incorrect\' (148 x 148)", subject.slots[0]?.texture?.description)
    }

    func testCanShowMissedBalls() {
        let missed = [Location(0, 0)]
        mockGame.stub(function: "missedBalls", return: missed)

        subject.showMissedBalls()

        XCTAssertEqual("<SKTexture> \'Miss\' (148 x 148)", subject.slots[0]?.texture?.description)
    }

    func testCanShowCorrectBalls() {
        let correct = [Location(0, 0)]
        mockGame.stub(function: "correctBalls", return: correct)

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

    class MockGame: Mock, Game {
        var moxie = Moxie()

        var probes = 0
        var marks = [Location : Bool]()
        var size = 0

        func placeAt(column: Int, andRow row: Int) {
            record(function: "placeAt", wasCalledWith: [column, row])
        }

        func markBallAt(column: Int, andRow row: Int) {
            record(function: "markBallAt", wasCalledWith: [column, row])
        }

        func removeMarkAt(column: Int, andRow row: Int) {
            record(function: "removeMarkAt", wasCalledWith: [column, row])
        }

        var isFinishable: Bool {
            return value(forFunction: "isFinishable") ?? false
        }

        var incorrectBalls: [Location] {
            return value(forFunction: "incorrectBalls") ?? []
        }

        var missedBalls: [Location] {
            return value(forFunction: "missedBalls") ?? []
        }

        var correctBalls: [Location] {
            return value(forFunction: "correctBalls") ?? []
        }

        var score: Int {
            return value(forFunction: "score") ?? 0
        }

        func probe(entry: Int) -> ExitResult? {
            return value(forFunction: "probe") ?? .hit
        }
    }

    class MockLevel: Mock, Level {
        var moxie = Moxie()

        var par: Int {
            return value(forFunction: "par") ?? 0
        }

        var balls: [Location] {
            return value(forFunction: "balls") ?? [Location]()
        }
    }
}
