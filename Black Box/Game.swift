import CoreGraphics

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

    public func whichEntryPoint(_ f: CGFloat) -> Int? {
        switch f {
        case 81..<157:
            return 1
        case 157..<233:
            return 2
        case 233..<309:
            return 3
        case 309..<385:
            return 4
        case 385..<461:
            return 5
        case 461..<537:
            return 6
        case 537..<613:
            return 7
        case 613..<689:
            return 8
        default:
            return nil
        }
    }

    func entryPointNumber(coordinates: CGPoint) -> Int? {
        if leftEntryPointZone(coordinates: coordinates) {
            if let result = whichEntryPoint(coordinates.y) {
                return 9 - result
            }
        }
        if bottomEntryPointZone(coordinates: coordinates) {
            if let result = whichEntryPoint(coordinates.x) {
                return result + 8
            }
        }
        if rightEntryPointZone(coordinates: coordinates) {
            if let result = whichEntryPoint(coordinates.y) {
                return result + 16
            }
        }
        if topEntryPointZone(coordinates: coordinates) {
            if let result = whichEntryPoint(coordinates.x) {
                return 9 - result + 24
            }
        }
        return nil
    }

    func leftEntryPointZone(coordinates: CGPoint) -> Bool {
        return (
            coordinates.x >= 5 &&
                coordinates.x < 81 &&
                coordinates.y >= 81 &&
                coordinates.y < 689)
    }

    func bottomEntryPointZone(coordinates: CGPoint) -> Bool {
        return (
            coordinates.x >= 81 &&
                coordinates.x < 689 &&
                coordinates.y >= 5 &&
                coordinates.y < 81)
    }

    func rightEntryPointZone(coordinates: CGPoint) -> Bool {
        return (
            coordinates.x >= 689 &&
                coordinates.x < 765 &&
                coordinates.y >= 81 &&
                coordinates.y < 689)
    }

    func topEntryPointZone(coordinates: CGPoint) -> Bool {
        return (
            coordinates.x >= 81 &&
                coordinates.x < 689 &&
                coordinates.y >= 689 &&
                coordinates.y < 765)
    }

    func slotNumber(coordinates: CGPoint) -> Int? {
        if pointInBox(coordinates, (81, 81), (688, 688)) {
            let column = Int(ceil((coordinates.x - 80.0)/76.0))
            let row = Int(8.0 - ceil((coordinates.y - 80.0)/76))

            return 8*row + column
        }
        return nil
    }

    func pointInBox(
        _ coordinates: CGPoint,
        _ point1: (x: Int, y: Int),
          _ point2: (x: Int, y: Int)
        ) -> Bool {

        let theX = Int(coordinates.x)
        let theY = Int(coordinates.y)
        switch (theX, theY) {
        case (point1.x...point2.x, point1.y...point2.y):
            return true
        default:
            return false
        }
    }
}
