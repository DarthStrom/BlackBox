struct Board {
    var slots = [Location: Bool]()
    var entries = [Location: Int]()

    init() {
        clearSlots()
        populateEntries()
    }

    mutating func clearSlots() {
        for y in 0...7 {
            for x in 0...7 {
                slots[Location(x, y)] = false
            }
        }
    }

    mutating func populateEntries() {
        for n in 1...8 {
            entries[Location(-1, n-1)] = n
        }
        for n in 9...16 {
            entries[Location(n-9, 8)] = n
        }
        for n in 17...24 {
            entries[Location(8, 24-n)] = n
        }
        for n in 25...32 {
            entries[Location(32-n, -1)] = n
        }
    }

    mutating func placeAt(column: Int, andRow row: Int) {
        slots[Location(column, row)] = true
    }

    func getEntryPointAt(column: Int, andRow row: Int) -> Int? {
        return entries[Location(column, row)]
    }

    func getSlotAt(column: Int, andRow row: Int) -> Bool {
        if let result = slots[Location(column, row)] {
            return result
        }
        return false
    }

    func getLocationFor(entry: Int) -> Location? {
        switch entry {
        case 1...8:
            return Location(-1, entry - 1)
        case 9...16:
            return Location(entry - 9, 8)
        case 17...24:
            return Location(8, 24 - entry)
        case 25...32:
            return Location(32 - entry, -1)
        default:
            return nil
        }
    }

    func getDirectionFor(entry: Int) -> Direction? {
        switch entry {
        case 1...8:
            return .right
        case 9...16:
            return .up
        case 17...24:
            return .left
        case 25...32:
            return .down
        default:
            return nil
        }
    }

    func isInBox(position: Location) -> Bool {
        if let _ = slots[position] {
            return true
        }
        return false
    }

}
