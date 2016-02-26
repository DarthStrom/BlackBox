import SpriteKit

class GameScene: SKScene {
    var detours = 0
    var game: Game?
    var level: Level?
    var entryPoints = [Int: EntryPoint](minimumCapacity: 32)
    var slots = [Int: Slot](minimumCapacity: 64)

    let soundMarkBall = SKAction.playSoundFileNamed("Mark.wav", waitForCompletion: false)
    let soundProbe = SKAction.playSoundFileNamed("Probe.wav", waitForCompletion: false)
    let soundSuccess = SKAction.playSoundFileNamed("Success.wav", waitForCompletion: true)
    let soundFailure = SKAction.playSoundFileNamed("Failure.wav", waitForCompletion: true)
    let soundNewGame = SKAction.playSoundFileNamed("NewGame.wav", waitForCompletion: false)

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

    func whichEntryPoint(f: CGFloat) -> Int? {
        switch f {
        case 81..<157:
            return 1
        case 157..<233:
            return 2
        case 233..<309:
            return 3
        case 309..<385:
            return 4
        case 385..<461:
            return 5
        case 461..<537:
            return 6
        case 537..<613:
            return 7
        case 613..<689:
            return 8
        default:
            return nil
        }
    }

    func entryPointNumber(coordinates: CGPoint) -> Int? {
        if leftEntryPointZone(coordinates) {
            if let result = whichEntryPoint(coordinates.y) {
                return 9 - result
            }
        }
        if bottomEntryPointZone(coordinates) {
            if let result = whichEntryPoint(coordinates.x) {
                return result + 8
            }
        }
        if rightEntryPointZone(coordinates) {
            if let result = whichEntryPoint(coordinates.y) {
                return result + 16
            }
        }
        if topEntryPointZone(coordinates) {
            if let result = whichEntryPoint(coordinates.x) {
                return 9 - result + 24
            }
        }
        return nil
    }

    func leftEntryPointZone(coordinates: CGPoint) -> Bool {
        return (coordinates.x >= 5 && coordinates.x < 81 && coordinates.y >= 81 && coordinates.y < 689)
    }

    func bottomEntryPointZone(coordinates: CGPoint) -> Bool {
        return (coordinates.x >= 81 && coordinates.x < 689 && coordinates.y >= 5 && coordinates.y < 81)
    }

    func rightEntryPointZone(coordinates: CGPoint) -> Bool {
        return (coordinates.x >= 689 && coordinates.x < 765 && coordinates.y >= 81 && coordinates.y < 689)
    }

    func topEntryPointZone(coordinates: CGPoint) -> Bool {
        return (coordinates.x >= 81 && coordinates.x < 689 && coordinates.y >= 689 && coordinates.y < 765)
    }

    func slotNumber(coordinates: CGPoint) -> Int? {
        if pointInBox(coordinates, (81, 81), (688, 688)) {
            let column = Int(ceil((coordinates.x - 80.0)/76.0))
            let row = Int(8.0 - ceil((coordinates.y - 80.0)/76))

            return 8*row + column
        }
        return nil
    }

    func pointInBox(coordinates: CGPoint, _ point1: (x: Int, y: Int), _ point2: (x: Int, y: Int)) -> Bool {
        let theX = Int(coordinates.x)
        let theY = Int(coordinates.y)
        switch (theX, theY) {
        case (point1.x...point2.x, point1.y...point2.y):
            return true
        default:
            return false
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
        if let entryPoint = entryPointNumber(location), p = self.entryPoints[entryPoint] {
            shootFrom(p)
        }
        if let slot = slotNumber(location), s = self.slots[slot - 1] {
            toggle(s)
        }
    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            handleTouch(touch.locationInNode(self))
        }
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
