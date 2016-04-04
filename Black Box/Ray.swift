class Ray {
    let entry: Int
    let board: Board

    init(entry: Int, board: Board) {
        self.entry = entry
        self.board = board
    }

    func shoot() -> ExitResult? {
        if var position = board.getLocationForEntry(entry) {
            if let direction = board.getDirectionForEntry(entry) {
                if willHitFrom(position, direction: direction) {
                    return .Hit
                }
                if willDetourFrom(position, direction: direction) {
                    return .Reflection
                }
                position = getNewPositionFrom(position, direction: direction)
                return shootFrom(position, direction: direction)
            }
        }
        return nil
    }

    func shootFrom(position: Location, direction: Direction) -> ExitResult? {
        if board.isInBox(position) {
            if board.getSlotAtColumn(
                position.x, andRow: position.y) || willHitFrom(position, direction: direction) {

                return .Hit
            }
            if willReflectFrom(position, direction: direction) {
                return .Reflection
            }

            let newDirection = getNewDirectionFrom(position, direction: direction)
            let newPosition = getNewPositionFrom(position, direction: newDirection)

            return shootFrom(newPosition, direction: newDirection)
        }
        if let exitPoint = board.getEntryPointAtColumn(position.x, andRow: position.y) {
            return .Detour(exitPoint)
        }
        return nil
    }

    func willDetourFrom(position: Location, direction: Direction) -> Bool {
        let newDirection = getNewDirectionFrom(position, direction: direction)
        return newDirection != direction
    }

    func willHitFrom(position: Location, direction: Direction) -> Bool {
        switch direction {
        case .Up:
            return board.getSlotAtColumn(position.x, andRow: position.y - 1)
        case .Down:
            return board.getSlotAtColumn(position.x, andRow: position.y + 1)
        case .Left:
            return board.getSlotAtColumn(position.x - 1, andRow: position.y)
        case .Right:
            return board.getSlotAtColumn(position.x + 1, andRow: position.y)
        }
    }

    func willReflectFrom(position: Location, direction: Direction) -> Bool {
        switch direction {
        case .Up:
            return board.getSlotAtColumn(position.x - 1, andRow: position.y - 1) &&
                board.getSlotAtColumn(position.x + 1, andRow: position.y - 1)
        case .Down:
            return board.getSlotAtColumn(position.x - 1, andRow: position.y + 1) &&
                board.getSlotAtColumn(position.x + 1, andRow: position.y + 1)
        case .Left:
            return board.getSlotAtColumn(position.x - 1, andRow: position.y - 1) &&
                board.getSlotAtColumn(position.x - 1, andRow: position.y + 1)
        case .Right:
            return board.getSlotAtColumn(position.x + 1, andRow: position.y - 1) &&
                board.getSlotAtColumn(position.x + 1, andRow: position.y + 1)
        }
    }

    func getNewPositionFrom(position: Location, direction: Direction) -> Location {
        switch direction {
        case .Up:
            return Location(x: position.x, y: position.y - 1)
        case .Down:
            return Location(x: position.x, y: position.y + 1)
        case .Left:
            return Location(x: position.x - 1, y: position.y)
        case .Right:
            return Location(x: position.x + 1, y: position.y)
        }
    }

    func getNewDirectionFrom(position: Location, direction: Direction) -> Direction {
        switch direction {
        case .Up:
            return getNewDirectionGoingUpFrom(position)
        case .Down:
            return getNewDirectionGoingDownFrom(position)
        case .Left:
            return getNewDirectionGoingLeftFrom(position)
        case .Right:
            return getNewDirectionGoingRightFrom(position)
        }
    }

    func getNewDirectionGoingUpFrom(position: Location) -> Direction {
        if board.getSlotAtColumn(position.x - 1, andRow: position.y - 1) {
            return .Right
        }
        if board.getSlotAtColumn(position.x + 1, andRow: position.y - 1) {
            return .Left
        }
        return .Up
    }

    func getNewDirectionGoingDownFrom(position: Location) -> Direction {
        if board.getSlotAtColumn(position.x - 1, andRow: position.y + 1) {
            return .Right
        }
        if board.getSlotAtColumn(position.x + 1, andRow: position.y + 1) {
            return .Left
        }
        return .Down
    }

    func getNewDirectionGoingLeftFrom(position: Location) -> Direction {
        if board.getSlotAtColumn(position.x - 1, andRow: position.y - 1) {
            return .Down
        }
        if board.getSlotAtColumn(position.x - 1, andRow: position.y + 1) {
            return .Up
        }
        return .Left
    }

    func getNewDirectionGoingRightFrom(position: Location) -> Direction {
        if board.getSlotAtColumn(position.x + 1, andRow: position.y - 1) {
            return .Down
        }
        if board.getSlotAtColumn(position.x + 1, andRow: position.y + 1) {
            return .Up
        }
        return .Right
    }
}
