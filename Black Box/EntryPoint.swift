import SpriteKit

class EntryPoint: SKSpriteNode {
  var number = 0
  
  class func entryPoint(number: Int, imageNamed: String) -> EntryPoint {
    let sprite = EntryPoint(imageNamed: imageNamed)
    
    sprite.number = number
    sprite.name = "Entry\(number)"
    return sprite
  }
}