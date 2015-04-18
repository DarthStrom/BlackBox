class Level {
  var par: Int?
  var balls = [Location]()
  
  init(number: Int) {
    if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Game\(number)") {
      if let ballsArray: AnyObject = dictionary["balls"] {
        for (row, rowArray) in enumerate(ballsArray as! [[Int]]) {
          for (column, value) in enumerate(rowArray) {
            if value == 1 {
              balls.append(Location(x: column, y: row))
            }
          }
        }
      }
      if let par: AnyObject = dictionary["par"] {
        self.par = par as? Int
      }
    }
  }
}