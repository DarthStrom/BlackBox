class Level {
    var par: Int?
    var balls = [Location]()

    init(number: Int) {
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(
            filename: "Game\(number)") {
            if let ballsArray = dictionary["balls"] as? [[Int]] {
                for (row, rowArray) in ballsArray.enumerated() {
                    for (column, value) in rowArray.enumerated() {
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
