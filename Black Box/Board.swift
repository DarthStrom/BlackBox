class Board {
    var slots = [Location: Bool]()
    var entries = [Location: Int]()

    init() {
        clearSlots()
        populateEntries()
    }

    func clearSlots() {
        for y in 0...7 {
            for x in 0...7 {
                slots[Location(x: x, y: y)] = false
            }
        }
    }

    func populateEntries() {
        for n in 1...8 {
            entries[Location(x: -1, y: n-1)] = n
        }
        for n in 9...16 {
            entries[Location(x: n-9, y: 8)] = n
        }
        for n in 17...24 {
            entries[Location(x: 8, y: 24-n)] = n
        }
        for n in 25...32 {
            entries[Location(x: 32-n, y: -1)] = n
        }
    }

    func placeAt(column: Int, andRow row: Int) {
        slots[Location(x: column, y: row)] = true
    }

    func getEntryPointAt(column: Int, andRow row: Int) -> Int? {
        return entries[Location(x: column, y: row)]
    }

    func getSlotAt(column: Int, andRow row: Int) -> Bool {
        if let result = slots[Location(x: column, y: row)] {
            return result
        }
        return false
    }

    func getLocationFor(entry: Int) -> Location? {
        switch entry {
        case 1...8:
            return Location(x: -1, y: entry - 1)
        case 9...16:
            return Location(x: entry - 9, y: 8)
        case 17...24:
            return Location(x: 8, y: 24 - entry)
        case 25...32:
            return Location(x: 32 - entry, y: -1)
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
