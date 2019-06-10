import Foundation

func randoBetweenOneAnd(_ upperLimit: Int) -> Int {
    return Int(arc4random_uniform(UInt32(upperLimit))) + 1
}
