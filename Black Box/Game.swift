public class Game {
    public var probes = 0
    public var marks = [Location: Bool]()
    public let size: Int

    var board = Board()

    public init(size: Int) {
        self.size = size
    }

    public init(balls: [Location]) {
        size = balls.count
        for ball in balls {
            placeAt(column: ball.x, andRow: ball.y)
        }
    }

    public func probe(entry: Int) -> ExitResult? {
        probes += 1

        let ray = Ray(entry: entry, board: board)
        return ray.shoot()
    }

    public func placeAt(column: Int, andRow row: Int) {
        board.placeAt(column: column, andRow: row)
    }

    public func markBallAt(column: Int, andRow row: Int) {
        marks.updateValue(true, forKey: Location(x: column, y: row))
    }

    public func removeMarkAt(column: Int, andRow row: Int) {
        marks.removeValue(forKey: Location(x: column, y: row))
    }

    public var isFinishable: Bool {
        return marks.count == size
    }

    public var score: Int {
        return probes + incorrectBalls.count * 5
    }

    public var incorrectBalls: [Location] {
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

    public var missedBalls: [Location] {
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

    public var correctBalls: [Location] {
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
