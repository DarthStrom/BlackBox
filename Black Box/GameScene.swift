import SpriteKit

class GameScene: SKScene {
  var detours = 0
  let game = Game(balls: 4)
  
  func isFinishable() -> Bool {
    return game.isFinishable()
  }
  
  func getProbes() -> String {
    return "\(game.guesses)"
  }
  
  func getIncorrectBalls() -> String {
    return "\(game.incorrectBalls().count * 5)"
  }
  
  func getScore() -> String {
    return "\(game.getScore())"
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
    for ball in game.incorrectBalls() {
      if let mark = childNodeWithName("Slot\(ball.x)\(ball.y)") as? Slot {
        mark.texture = SKTexture(imageNamed: "Incorrect")
      }
    }
  }
  
  func showMissedBalls() {
    for ball in game.missedBalls() {
      if let miss = childNodeWithName("Slot\(ball.x)\(ball.y)") as? Slot {
        miss.texture = SKTexture(imageNamed: "Miss")
        miss.hidden = false
      }
    }
  }
  
  func showCorrectBalls() {
    for ball in game.correctBalls() {
      if let mark = childNodeWithName("Slot\(ball.x)\(ball.y)") as? Slot {
        mark.texture = SKTexture(imageNamed: "Correct")
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
    
    //TODO: real ball hiding
    game.placeAtColumn(1, andRow: 1)
    game.placeAtColumn(1, andRow: 3)
    game.placeAtColumn(3, andRow: 4)
    game.placeAtColumn(7, andRow: 7)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    for touch: AnyObject in touches {
      let location = touch.locationInNode(self)
      println("location: (\(location.x),\(location.y))")
      
      // do some stuff
      if let entryPoint = self.nodeAtPoint(location) as? EntryPoint {
        println(entryPoint.name!)
        entryPoint.hidden = false
        switch game.guess(entryPoint.number) {
        case .Some(.Hit):
          entryPoint.texture = SKTexture(imageNamed: "Hit")
        case .Some(.Detour(let exitPoint)):
          detours = (detours % 9) + 1
          let exitPoint = self.childNodeWithName("Entry\(exitPoint)") as EntryPoint
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
        println(slot.name!)
        if slot.hidden {
          slot.hidden = false
          game.markBallAtColumn(slot.column, andRow: slot.row)
        } else {
          slot.hidden = true
          game.removeMarkAtColumn(slot.column, andRow: slot.row)
        }
      }
    }
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
}
