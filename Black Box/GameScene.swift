import SpriteKit

class GameScene: SKScene {
    var detours = 0
    var game: Game?
    var level: Level?
    
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
                runAction(soundSuccess)
            } else {
                runAction(soundFailure)
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
        switch number {
        case 1...8:
            input.position = CGPoint(x: 5, y: 689 - (number * 76))
        case 9...16:
            input.position = CGPoint(x: 81 + ((number - 9) * 76), y: 5)
        case 17...24:
            input.position = CGPoint(x: 689, y: 689 - ((25 - number) * 76))
        case 25...32:
            input.position = CGPoint(x: 81 + ((32 - number) * 76), y: 689)
        default:
            input.position = CGPoint(x: 0, y: 0)
        }
        input.anchorPoint = CGPoint(x: 0, y: 0)
        input.hidden = true
        addChild(input)
    }
    
    func addSlotAtColumn(column: Int, andRow row: Int) {
        let slot = Slot.slot(column: column, row: row, imageNamed: "Guess")
        slot.anchorPoint = CGPoint(x: 0, y: 0)
        slot.position = CGPoint(x: 81 + column * 76, y: 81 + (7 - row) * 76)
        slot.hidden = true
        addChild(slot)
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
        
        let background = SKSpriteNode(imageNamed: "blackboxboard")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 0)
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
        if let balls = level?.balls {
            game = Game(balls: level!.balls)
            runAction(soundNewGame)
        } else {
            println("Couldn't create game.")
        }
    }
    
    func randoBetweenOneAnd(upperLimit: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperLimit))) + 1
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            println("location: (\(location.x),\(location.y))")
            
            // do some stuff
            if let entryPoint = self.nodeAtPoint(location) as? EntryPoint {
                runAction(soundProbe)
                println(entryPoint.name!)
                entryPoint.hidden = false
                switch game?.probe(entryPoint.number) {
                case .Some(.Hit):
                    entryPoint.texture = SKTexture(imageNamed: "Hit")
                case .Some(.Detour(let exitPoint)):
                    detours = (detours % 12) + 1
                    let exitPoint = self.childNodeWithName("Entry\(exitPoint)") as! EntryPoint
                    entryPoint.texture = SKTexture(imageNamed: "Detour\(detours)")
                    exitPoint.texture = SKTexture(imageNamed: "Detour\(detours)")
                    exitPoint.hidden = false
                case .Some(.Reflection):
                    entryPoint.texture = SKTexture(imageNamed: "Reflection")
                case .None:
                    entryPoint.hidden = true
                }
            }
            if let slot = self.nodeAtPoint(location) as? Slot {
                runAction(soundMarkBall)
                println(slot.name!)
                if slot.hidden {
                    slot.hidden = false
                    game?.markBallAtColumn(slot.column, andRow: slot.row)
                } else {
                    slot.hidden = true
                    game?.removeMarkAtColumn(slot.column, andRow: slot.row)
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
