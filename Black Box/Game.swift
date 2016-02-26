public class Game {
    public var probes = 0
    public var marks = [Location: Bool]()
    public let size: Int

    let board = Board()

    public init(size: Int) {
        self.size = size
    }

    public init(balls: [Location]) {
        size = balls.count
        for ball in balls {
            placeAtColumn(ball.x, andRow: ball.y)
        }
    }

    public func probe(entry: Int) -> ExitResult? {
        probes += 1

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
        return marks.count == size
    }

    public func getScore() -> Int {
        return probes + incorrectBalls().count * 5
    }

    public func incorrectBalls() -> [Location] {
        var result = [Location]()
        for mark in marks {
            if let slot = board.slots[mark.0] {
                if !slot {
                    result.append(mark.0)
                }
            }
        }
        return result
    }

    public func missedBalls() -> [Location] {
        var result = [Location]()
        for slot in board.slots {
            if slot.1 {
                if let mark = marks[slot.0] {
                    if !mark {
                        result.append(slot.0)
                    }
                } else {
                    result.append(slot.0)
                }
            }
        }
        return result
    }

    public func correctBalls() -> [Location] {
        var result = [Location]()
        for slot in board.slots {
            if slot.1 {
                if let mark = marks[slot.0] {
                    if mark {
                        result.append(slot.0)
                    }
                }
            }
        }
        return result
    }

}
