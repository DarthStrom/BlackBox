import SpriteKit

class GameScene: SKScene {

    let soundMarkBall = SKAction.playSoundFileNamed("Mark.wav", waitForCompletion: false)
    let soundProbe = SKAction.playSoundFileNamed("Probe.wav", waitForCompletion: false)
    let soundSuccess = SKAction.playSoundFileNamed("Success.wav", waitForCompletion: true)
    let soundFailure = SKAction.playSoundFileNamed("Failure.wav", waitForCompletion: true)
    let soundNewGame = SKAction.playSoundFileNamed("NewGame.wav", waitForCompletion: false)

    var detours = 0
    var game: Game?
    var level: Level?
    var entryPoints = [Int: EntryPoint](minimumCapacity: 32)
    var slots = [Int: Slot](minimumCapacity: 64)

    // MARK: - SKScene

    override init(size: CGSize) {
        super.init(size: size)

        let background = SKSpriteNode(imageNamed: "BlackboxBoard")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = 1
        addChild(background)

        for i in 1...32 {
            addEntryPoint(i)
        }

        for y in 0...7 {
            for x in 0...7 {
                addSlotAtColumn(x, andRow: y)
            }
        }

        createGame(randoBetweenOneAnd(80))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            handleTouch(touch.locationInNode(self))
        }
    }

    // MARK: - Game state

    func isFinishable() -> Bool {
        if let result = game?.isFinishable() {
            return result
        }
        return false
    }

    func getProbes() -> String {
        if let result = game?.probes {
            return String(result)
        }
        return "No game"
    }

    func getIncorrectBalls() -> String {
        if let result = game?.incorrectBalls() {
            if result.count == 0 {
                playSound(soundSuccess)
            } else {
                playSound(soundFailure)
            }
            return String(result.count * 5)
        }
        return "No game"
    }

    func getPar() -> Int? {
        return level?.par
    }

    func getScore() -> String {
        if let result = game?.getScore() {
            return String(result)
        }
        return "No game"
    }

    func showIncorrectBalls() {
        if let incorrectBalls = game?.incorrectBalls() {
            for ball in incorrectBalls {
                if let mark = childNodeWithName("Slot\(ball.x)\(ball.y)") as? Slot {
                    mark.texture = SKTexture(imageNamed: "Incorrect")
                }
            }
        }
    }

    func showMissedBalls() {
        if let missedBalls = game?.missedBalls() {
            for ball in missedBalls {
                if let miss = childNodeWithName("Slot\(ball.x)\(ball.y)") as? Slot {
                    miss.texture = SKTexture(imageNamed: "Miss")
                    miss.hidden = false
                }
            }
        }
    }

    func showCorrectBalls() {
        if let correctBalls = game?.correctBalls() {
            for ball in correctBalls {
                if let mark = childNodeWithName("Slot\(ball.x)\(ball.y)") as? Slot {
                    mark.texture = SKTexture(imageNamed: "Correct")
                }
            }
        }
    }

    // MARK: - Setup

    func addEntryPoint(number: Int) {
        let input = EntryPoint.entryPoint(number, imageNamed: "Hit")

        if let coordinates = self.entryPointCoordinates(number) {
            input.position = coordinates
            input.anchorPoint = CGPoint(x: 0, y: 0)
            input.hidden = true
            input.zPosition = 2
            self.addChild(input)
            self.entryPoints[number] = input
        }
    }

    func createGame(number: Int) {
        level = Level(number: number)
        if let _ = level?.balls {
            game = Game(balls: level!.balls)
            playSound(soundNewGame)
        } else {
            print("Couldn't create game.")
        }
    }

    func randoBetweenOneAnd(upperLimit: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperLimit))) + 1
    }

    func playSound(sound: SKAction) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let audio = defaults.stringForKey("audio") {
            if audio == "on" {
                runAction(sound)
            }
        }
    }

    func entryPointCoordinates(number: Int) -> CGPoint? {
        switch number {
        case 1...8:
            return CGPoint(x: 5, y: 689 - (number * 76))
        case 9...16:
            return CGPoint(x: 81 + ((number - 9) * 76), y: 5)
        case 17...24:
            return CGPoint(x: 689, y: 689 - ((25 - number) * 76))
        case 25...32:
            return CGPoint(x: 81 + ((32 - number) * 76), y: 689)
        default:
            return nil
        }
    }

    func addSlotAtColumn(column: Int, andRow row: Int) {
        let slot = Slot.slot(column: column, row: row, imageNamed: "Guess")
        slot.anchorPoint = CGPoint(x: 0, y: 0)
        slot.position = CGPoint(x: 81 + column * 76, y: 81 + (7 - row) * 76)
        slot.hidden = true
        slot.zPosition = 2
        self.addChild(slot)
        self.slots[row*8 + column] = slot
    }

    // MARK: - Shooting

    func shootFrom(entryPoint: EntryPoint) {
        playSound(soundProbe)
        entryPoint.hidden = false
        switch game?.probe(entryPoint.number) {
        case .Some(.Hit):
            let texture = SKTexture(imageNamed: "Hit")
            entryPoint.texture = texture
        case .Some(.Detour(let exitPoint)):
            detours = (detours % 12) + 1
            let exitPoint = self.childNodeWithName("Entry\(exitPoint)") as? EntryPoint
            let texture = SKTexture(imageNamed: "Detour\(detours)")
            entryPoint.texture = texture
            exitPoint?.texture = texture
            exitPoint?.hidden = false
        case .Some(.Reflection):
            let texture = SKTexture(imageNamed: "Reflection")
            entryPoint.texture = texture
        case .None:
            entryPoint.hidden = true
        }
    }

    func toggle(slot: Slot) {
        playSound(soundMarkBall)
        if slot.hidden {
            slot.hidden = false
            game?.markBallAtColumn(slot.column, andRow: slot.row)
        } else {
            slot.hidden = true
            game?.removeMarkAtColumn(slot.column, andRow: slot.row)
        }
    }

    func handleTouch(location: CGPoint) {
        if let entryPoint = game?.entryPointNumber(location), p = self.entryPoints[entryPoint] {
            shootFrom(p)
        }
        if let slot = game?.slotNumber(location), s = self.slots[slot - 1] {
            toggle(s)
        }
    }

}
