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

    var border: CGFloat {
        return 0.005208333333333 * size.width
    }

    var cellWidth: CGFloat {
        return (size.width - 2 * border) / 10.0
    }

    // MARK: - SKScene

    override init(size: CGSize) {
        super.init(size: size)

        backgroundColor = .clear

        for i in 1...32 {
            addEntryPoint(number: i)
        }

        for y in 0...7 {
            for x in 0...7 {
                addSlotAt(column: x, andRow: y)
            }
        }

        createGame(number: randoBetweenOneAnd(80))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            handleTouch(touch.location(in: self))
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
                if let mark = childNode(withName: "Slot\(ball.x)\(ball.y)") as? Slot {
                    mark.texture = SKTexture(imageNamed: "Incorrect")
                }
            }
        }
    }

    func showMissedBalls() {
        if let missedBalls = game?.missedBalls() {
            for ball in missedBalls {
                if let miss = childNode(withName: "Slot\(ball.x)\(ball.y)") as? Slot {
                    miss.texture = SKTexture(imageNamed: "Miss")
                    miss.isHidden = false
                }
            }
        }
    }

    func showCorrectBalls() {
        if let correctBalls = game?.correctBalls() {
            for ball in correctBalls {
                if let mark = childNode(withName: "Slot\(ball.x)\(ball.y)") as? Slot {
                    mark.texture = SKTexture(imageNamed: "Correct")
                }
            }
        }
    }

    // MARK: - Setup

    func addEntryPoint(number: Int) {
        let input = EntryPoint.entryPoint(number: number, imageNamed: "Hit")

        if let coordinates = self.entryPointCoordinates(number) {
            input.position = coordinates
            input.size = CGSize(width: cellWidth, height: cellWidth)
            input.anchorPoint = CGPoint(x: 0, y: 0)
            input.isHidden = true
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

    func randoBetweenOneAnd(_ upperLimit: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperLimit))) + 1
    }

    func playSound(_ sound: SKAction) {
        let defaults = UserDefaults.standard
        if let audio = defaults.string(forKey: "audio") {
            if audio == "on" {
                run(sound)
            }
        }
    }

    func entryPointCoordinates(_ number: Int) -> CGPoint? {
        let cgNum = CGFloat(number)
        switch number {
        case 1...8:
            return CGPoint(x: border + 1, y: size.width - cellWidth - border - (cgNum * cellWidth))
        case 9...16:
            return CGPoint(x: cellWidth + border + ((cgNum - 9) * cellWidth), y: border + 1)
        case 17...24:
            return CGPoint(x: size.width - cellWidth - border,
                           y: size.width - cellWidth - border - ((25 - cgNum) * cellWidth))
        case 25...32:
            return CGPoint(x: cellWidth + border + ((32 - cgNum) * cellWidth),
                           y: size.width - cellWidth - border)
        default:
            return nil
        }
    }

    func addSlotAt(column: Int, andRow row: Int) {
        let slot = Slot.slot(column: column, row: row, imageNamed: "Guess")
        let cgColumn = CGFloat(column)
        let cgRow = CGFloat(row)
        slot.anchorPoint = CGPoint(x: 0, y: 0)
        slot.position = CGPoint(x: cellWidth + border + cgColumn * cellWidth,
                                y: cellWidth + border + (7 - cgRow) * cellWidth)
        slot.size = CGSize(width: cellWidth, height: cellWidth)
        slot.isHidden = true
        slot.zPosition = 2
        self.addChild(slot)
        self.slots[row*8 + column] = slot
    }

    // MARK: - Shooting

    func shootFrom(_ entryPoint: EntryPoint) {
        playSound(soundProbe)
        entryPoint.isHidden = false
        switch game?.probe(entry: entryPoint.number) {
        case .some(.hit):
            let texture = SKTexture(imageNamed: "Hit")
            entryPoint.texture = texture
        case .some(.detour(let exitPoint)):
            detours = (detours % 12) + 1
            let exitPoint = self.childNode(withName: "Entry\(exitPoint)") as? EntryPoint
            let texture = SKTexture(imageNamed: "Detour\(detours)")
            entryPoint.texture = texture
            exitPoint?.texture = texture
            exitPoint?.isHidden = false
        case .some(.reflection):
            let texture = SKTexture(imageNamed: "Reflection")
            entryPoint.texture = texture
        case .none:
            entryPoint.isHidden = true
        }
    }

    func toggle(slot: Slot) {
        playSound(soundMarkBall)
        if slot.isHidden {
            slot.isHidden = false
            game?.markBallAt(column: slot.column, andRow: slot.row)
        } else {
            slot.isHidden = true
            game?.removeMarkAt(column: slot.column, andRow: slot.row)
        }
    }

    func handleTouch(_ location: CGPoint) {
        print("touched: \(location)")
        if let entryPoint = entryPointNumber(coordinates: location),
            let p = self.entryPoints[entryPoint] {
            print("touched entry point: \(entryPoint)")
            shootFrom(p)
        }
        if let slot = slotNumber(coordinates: location), let s = self.slots[slot - 1] {
            print("touched slot: \(slot)")
            toggle(slot: s)
        }
    }

    public func whichEntryPoint(_ f: CGFloat) -> Int? {
        switch f {
        case (border + cellWidth)..<(border + cellWidth*2):
            return 1
        case (border + cellWidth*2)..<(border + cellWidth*3):
            return 2
        case (border + cellWidth*3)..<(border + cellWidth*4):
            return 3
        case (border + cellWidth*4)..<(border + cellWidth*5):
            return 4
        case (border + cellWidth*5)..<(border + cellWidth*6):
            return 5
        case (border + cellWidth*6)..<(border + cellWidth*7):
            return 6
        case (border + cellWidth*7)..<(border + cellWidth*8):
            return 7
        case (border + cellWidth*8)..<(border + cellWidth*9):
            return 8
        default:
            return nil
        }
    }

    func entryPointNumber(coordinates: CGPoint) -> Int? {
        if leftEntryPointZone(coordinates: coordinates) {
            if let result = whichEntryPoint(coordinates.y) {
                return 9 - result
            }
        }
        if bottomEntryPointZone(coordinates: coordinates) {
            if let result = whichEntryPoint(coordinates.x) {
                return result + 8
            }
        }
        if rightEntryPointZone(coordinates: coordinates) {
            if let result = whichEntryPoint(coordinates.y) {
                return result + 16
            }
        }
        if topEntryPointZone(coordinates: coordinates) {
            if let result = whichEntryPoint(coordinates.x) {
                return 9 - result + 24
            }
        }
        return nil
    }

    func leftEntryPointZone(coordinates: CGPoint) -> Bool {
        return (
            coordinates.x >= border &&
                coordinates.x < border + cellWidth &&
                coordinates.y >= border + cellWidth &&
                coordinates.y < size.width - border - cellWidth)
    }

    func bottomEntryPointZone(coordinates: CGPoint) -> Bool {
        return (
            coordinates.x >= border + cellWidth &&
                coordinates.x < size.width - border - cellWidth &&
                coordinates.y >= border &&
                coordinates.y < border + cellWidth)
    }

    func rightEntryPointZone(coordinates: CGPoint) -> Bool {
        return (
            coordinates.x >= size.width - border - cellWidth &&
                coordinates.x < size.width - border &&
                coordinates.y >= border + cellWidth &&
                coordinates.y < size.width - border - cellWidth)
    }

    func topEntryPointZone(coordinates: CGPoint) -> Bool {
        return (
            coordinates.x >= border + cellWidth &&
                coordinates.x < size.width - border - cellWidth &&
                coordinates.y >= size.width - border - cellWidth &&
                coordinates.y < size.width - border)
    }

    func slotNumber(coordinates: CGPoint) -> Int? {
        if pointInBox(coordinates,
                      (Int(cellWidth + border), Int(cellWidth + border)),
                      (Int(size.width - border - cellWidth),
                       Int(size.width - border - cellWidth))) {
            let column = Int(ceil((coordinates.x - (cellWidth + border))/cellWidth))
            let row = Int(8.0 - ceil((coordinates.y - (cellWidth + border))/cellWidth))

            return 8*row + column
        }
        return nil
    }

    func pointInBox(
        _ coordinates: CGPoint,
        _ point1: (x: Int, y: Int),
        _ point2: (x: Int, y: Int)
        ) -> Bool {

        let theX = Int(coordinates.x)
        let theY = Int(coordinates.y)
        switch (theX, theY) {
        case (point1.x...point2.x, point1.y...point2.y):
            return true
        default:
            return false
        }
    }
}
