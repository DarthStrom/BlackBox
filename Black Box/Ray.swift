class Ray {
    let entry: Int
    let board: Board

    init(entry: Int, board: Board) {
        self.entry = entry
        self.board = board
    }

    func shoot() -> ExitResult? {
        if var position = board.getLocationFor(entry: entry) {
            if let direction = board.getDirectionFor(entry: entry) {
                if willHitFrom(position, direction: direction) {
                    return .hit
                }
                if willDetourFrom(position, direction: direction) {
                    return .reflection
                }
                position = getNewPositionFrom(position, direction: direction)
                return shootFrom(position, direction: direction)
            }
        }
        return nil
    }

    func shootFrom(_ position: Location, direction: Direction) -> ExitResult? {
        if board.isInBox(position: position) {
            if board.getSlotAt(column: position.x, andRow: position.y)
                || willHitFrom(position, direction: direction) {

                return .hit
            }
            if willReflectFrom(position, direction: direction) {
                return .reflection
            }

            let newDirection = getNewDirectionFrom(position, direction: direction)
            let newPosition = getNewPositionFrom(position, direction: newDirection)

            return shootFrom(newPosition, direction: newDirection)
        }
        if let exitPoint = board.getEntryPointAt(column: position.x, andRow: position.y) {
            return .detour(exitPoint)
        }
        return nil
    }

    func willDetourFrom(_ position: Location, direction: Direction) -> Bool {
        let newDirection = getNewDirectionFrom(position, direction: direction)
        return newDirection != direction
    }

    func willHitFrom(_ position: Location, direction: Direction) -> Bool {
        switch direction {
        case .up:
            return board.getSlotAt(column: position.x, andRow: position.y - 1)
        case .down:
            return board.getSlotAt(column: position.x, andRow: position.y + 1)
        case .left:
            return board.getSlotAt(column: position.x - 1, andRow: position.y)
        case .right:
            return board.getSlotAt(column: position.x + 1, andRow: position.y)
        }
    }

    func willReflectFrom(_ position: Location, direction: Direction) -> Bool {
        switch direction {
        case .up:
            return board.getSlotAt(column: position.x - 1, andRow: position.y - 1) &&
                board.getSlotAt(column: position.x + 1, andRow: position.y - 1)
        case .down:
            return board.getSlotAt(column: position.x - 1, andRow: position.y + 1) &&
                board.getSlotAt(column: position.x + 1, andRow: position.y + 1)
        case .left:
            return board.getSlotAt(column: position.x - 1, andRow: position.y - 1) &&
                board.getSlotAt(column: position.x - 1, andRow: position.y + 1)
        case .right:
            return board.getSlotAt(column: position.x + 1, andRow: position.y - 1) &&
                board.getSlotAt(column: position.x + 1, andRow: position.y + 1)
        }
    }

    func getNewPositionFrom(_ position: Location, direction: Direction) -> Location {
        switch direction {
        case .up:
            return Location(x: position.x, y: position.y - 1)
        case .down:
            return Location(x: position.x, y: position.y + 1)
        case .left:
            return Location(x: position.x - 1, y: position.y)
        case .right:
            return Location(x: position.x + 1, y: position.y)
        }
    }

    func getNewDirectionFrom(_ position: Location, direction: Direction) -> Direction {
        switch direction {
        case .up:
            return getNewDirectionGoingUpFrom(position)
        case .down:
            return getNewDirectionGoingDownFrom(position)
        case .left:
            return getNewDirectionGoingLeftFrom(position)
        case .right:
            return getNewDirectionGoingRightFrom(position)
        }
    }

    func getNewDirectionGoingUpFrom(_ position: Location) -> Direction {
        if board.getSlotAt(column: position.x - 1, andRow: position.y - 1) {
            return .right
        }
        if board.getSlotAt(column: position.x + 1, andRow: position.y - 1) {
            return .left
        }
        return .up
    }

    func getNewDirectionGoingDownFrom(_ position: Location) -> Direction {
        if board.getSlotAt(column: position.x - 1, andRow: position.y + 1) {
            return .right
        }
        if board.getSlotAt(column: position.x + 1, andRow: position.y + 1) {
            return .left
        }
        return .down
    }

    func getNewDirectionGoingLeftFrom(_ position: Location) -> Direction {
        if board.getSlotAt(column: position.x - 1, andRow: position.y - 1) {
            return .down
        }
        if board.getSlotAt(column: position.x - 1, andRow: position.y + 1) {
            return .up
        }
        return .left
    }

    func getNewDirectionGoingRightFrom(_ position: Location) -> Direction {
        if board.getSlotAt(column: position.x + 1, andRow: position.y - 1) {
            return .down
        }
        if board.getSlotAt(column: position.x + 1, andRow: position.y + 1) {
            return .up
        }
        return .right
    }
}
