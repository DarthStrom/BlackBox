public class Game {
  public var guesses = 0
  public var marks = [Location: Bool]()
  
  let balls: Int
  let board = Board()
  
  public init(balls: Int) {
    self.balls = balls
  }
  
  public func guess(entry: Int) -> ExitResult? {
    guesses += 1
    
    let ray = Ray(entry: entry, board: board)
    return ray.shoot()
  }
  
  public func placeAtColumn(column: Int, andRow row: Int) {
    board.placeAtColumn(column, andRow: row)
  }
  
  public func markBallAtColumn(column: Int, andRow row: Int) {
    marks.updateValue(true, forKey: Location(x: column, y: row))
  }
  
  public func removeMarkAtColumn(column: Int, andRow row: Int) {
    marks.removeValueForKey(Location(x: column, y: row))
  }
  
  public func isFinishable() -> Bool {
    return marks.count == balls
  }
  
  public func getScore() -> Int {
    return guesses + incorrectBalls() * 5
  }
  
  func incorrectBalls() -> Int {
    var count = 0
    for mark in marks {
      if let slot = board.slots[mark.0] {
        if !slot {
          count += 1
        }
      }
    }
    return count
  }
}