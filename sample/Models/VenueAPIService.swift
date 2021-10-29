import Foundation
import CoreLocation

struct VenueAPIService {
    let location: CLLocation
    let url: URL?
    
    init(location: CLLocation) {
        let baseUrl = Environment.baseUrl.appendingPathComponent("venues/explore")
        var urlComponents = URLComponents(string: baseUrl.absoluteString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "section", value: "coffee"),
            URLQueryItem(name: "ll", value: "\(location.coordinate.latitude),\(location.coordinate.longitude)"),
            URLQueryItem(name: "v", value: "20210101"),
            URLQueryItem(name: "sortByDistance", value: "1"),
            URLQueryItem(name: "client_id", value: Environment.clientId),
            URLQueryItem(name: "client_secret", value: Environment.clientSecret)
        ]
        
        self.location = location
        self.url = urlComponents?.url
    }
}
