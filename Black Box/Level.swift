protocol Level {
    var par: Int { get }
    var balls: [Location] { get }
}

struct ComputerLevel: Level {
    var par: Int
    var balls = [Location]()

    init(number: Int) {
        let dictionary = [String: AnyObject].loadJSONFromBundle(filename: "Game\(number)")
        if let ballsArray = dictionary?["balls"] as? [[Int]] {
            for (row, rowArray) in ballsArray.enumerated() {
                for (column, value) in rowArray.enumerated() where value == 1 {
                    balls.append(Location(column, row))
                }
            }
        }
        self.par = dictionary?["par"] as? Int ?? 0
    }
}
