import XCTest
import CoreLocation
@testable import sample

class VenueAPIServiceTests: XCTestCase {

    func test_createService_isCorrect() {
        let location = CLLocation(latitude: CLLocationDegrees(40.759211),
                                  longitude: CLLocationDegrees(-73.984638))
        let service = VenueAPIService(location: location)
        
        guard let url = service.url else {
            XCTFail("A URL should have been generated for this service")
            return
        }
        
        guard let queryItems = URLComponents(string: url.absoluteString)?.queryItems else {
            XCTFail("This service should have query items")
            return
        }
        
        XCTAssertEqual(queryItems.count, 6)
        XCTAssertEqual(queryItems.filter { $0.name == "section" }.first?.value , "coffee")
        XCTAssertEqual(queryItems.filter { $0.name == "ll" }.first?.value , "\(location.coordinate.latitude),\(location.coordinate.longitude)")
        XCTAssertEqual(queryItems.filter { $0.name == "v" }.first?.value , "20210101")
        XCTAssertEqual(queryItems.filter { $0.name == "sortByDistance" }.first?.value , "1")
        XCTAssertEqual(queryItems.filter { $0.name == "client_id" }.first?.value , Environment.clientId)
        XCTAssertEqual(queryItems.filter { $0.name == "client_secret" }.first?.value , Environment.clientSecret)
    }

}
