public func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public struct Location {
    let x: Int, y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

// MARK: - Hashable
extension Location: Hashable {
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
}
