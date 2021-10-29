import XCTest
@testable import sample

class DecodingTests: XCTestCase {
    
    func test_venueDecoding() {
        guard let json = try? loadContents(of: "jsonResponse", with: "json") else {
            XCTFail("Couldn't fetch load contents of jsonResponse")
            return
        }
        do {
            let decoded = try JSONDecoder().decode(VenueResults.self, from: json)

            XCTAssertNotNil(decoded)
            
            guard let groups = decoded.response.groups.first else {
                XCTFail("You should have at least one group")
                return
            }
            
            XCTAssertEqual(groups.items.count, 30)
            
            let firstitem = groups.items[0]
            
            XCTAssertEqual(firstitem.venue.id, "49dbfd0ff964a520385f1fe3")
            XCTAssertEqual(firstitem.venue.name, "La Maison du Macaron")
            XCTAssertEqual(firstitem.venue.location.address, "132 W 23rd St")
            XCTAssertEqual(firstitem.venue.categories?.first?.name, "Bakery")
        } catch {
            XCTFail("Couldn't decode VenueResults from jsonResponse \(String(describing: error))")
        }
    }
    
    func test_venueItemGetters() {
        guard let json = try? loadContents(of: "jsonResponse", with: "json") else {
            XCTFail("Couldn't fetch load contents of jsonResponse")
            return
        }
        do {
            let decoded = try JSONDecoder().decode(VenueResults.self, from: json)

            XCTAssertNotNil(decoded)
            
            guard let groups = decoded.response.groups.first else {
                XCTFail("You should have at least one group")
                return
            }
            
            XCTAssertEqual(groups.items.count, 30)
            
            let firstitem = groups.items[0]
            
            XCTAssertEqual(firstitem.venue.id, "49dbfd0ff964a520385f1fe3")
            XCTAssertEqual(firstitem.venue.location.formattedAddress, "132 W 23rd St\nNew York\n10011")
            XCTAssertEqual(firstitem.venue.location.formattedDistance, "0.08m")
            XCTAssertEqual(firstitem.venue.formattedCategories, "Bakery")
        } catch {
            XCTFail("Couldn't decode VenueResults from jsonResponse \(String(describing: error))")
        }
    }
    
}
