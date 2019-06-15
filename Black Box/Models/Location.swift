public func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public struct Location: Hashable {
    let x: Int, y: Int

    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}
