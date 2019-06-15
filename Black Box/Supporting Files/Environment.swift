import Foundation

public enum Environment {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }

        return dict
    }()

    static let flurryApiKey: String = {
        guard let flurryApiKey = Environment.infoDictionary["FLURRY_API_KEY"] as? String else {
            fatalError("Flurry API Key not set in plist for this environment")
        }

        return flurryApiKey
    }()
}
