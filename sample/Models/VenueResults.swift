import Foundation

struct VenueResults: Decodable, Hashable {
    let response: VenuResponse
}

struct VenuResponse: Decodable, Hashable {
    let groups: [VenueGroup]
}

struct VenueGroup: Decodable, Hashable {
    let items: [VenueItem]
}

struct VenueItem: Decodable, Hashable, Identifiable {
    let venue: Venue
    
    var id: String {
        venue.id
    }
}

struct Venue: Decodable, Hashable {
    let id: String
    let name: String
    let location: Location
    let categories: [VenueCategory]?
    
    var formattedCategories: String {
        categories?.map(\.name).joined(separator: ",") ?? ""
    }
}

struct Location: Decodable, Hashable {
    let address: String?
    let distance: Int
    let postalCode: String?
    let city: String?
    
    var formattedAddress: String {
        [address, city, postalCode].compactMap { $0 }.joined(separator: "\n")
    }
    
    var formattedDistance: String {
        String(format: "%.2fm", Float(distance) / 1609.34)
    }
}

struct VenueCategory: Decodable, Hashable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "shortName"
    }
}
