import Foundation

struct Environment {

    // MARK: - Public members

    static let baseUrl: URL = url(forKey: "BASE_URL")
    static let clientId: String = string(forKey: "CLIENT_ID")
    static let clientSecret: String = string(forKey: "CLIENT_SECRET")

    // MARK: - Private members

    private static let environmentDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        guard let environment = dict["Environment"] as? [String: Any] else {
            fatalError("Plist missing environment variables")
        }
        return environment
    }()

    private static func url(forKey key: String) -> URL {
        guard let url = URL(string: string(forKey: key)) else {
            fatalError("\(key) value is not a valid URL")
        }
        return url
    }

    private static func string(forKey key: String) -> String {
        guard let stringValue = Environment.environmentDictionary[key] as? String else {
            fatalError("\(key) is not set in plist for this environment")
        }
        return stringValue
    }
}
