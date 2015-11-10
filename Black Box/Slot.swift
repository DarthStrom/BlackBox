import SpriteKit

class Slot: SKSpriteNode {
  var column = 0, row = 0
  
  class func slot(column column: Int, row: Int, imageNamed: String) -> Slot {
    let sprite = Slot(imageNamed: imageNamed)
    
    sprite.column = column
    sprite.row = row
    sprite.name = "Slot\(column)\(row)"
    return sprite
  }
}