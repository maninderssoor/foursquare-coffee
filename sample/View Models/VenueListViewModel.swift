import Foundation
import CoreLocation
import Combine
import UIKit

enum VenueSection {
    case main
}

enum VenueListError: Error {
    case exisiting(description: String)
    case parsing(description: String)
    case network(description: String)
}

class VenueListViewModel {
    
    private var cancellable: AnyCancellable?
    private var isFetching: Bool = false
    
    private let apiProvider: APIProvider
    
    weak var view: VenueListView?
    
    init(provider: APIProvider = URLSession.shared) {
        self.apiProvider = provider
    }
    
    func fetchData(with location: CLLocation) {
        guard !isFetching else { return }
        isFetching = true
        
        guard let url = VenueAPIService(location: location).url else {
            print("Error fetching a url with the venue API service")
            return
        }
        
        self.cancellable = apiProvider.apiResponse(for: url)
            .mapError { error in
                VenueListError.network(description: error.localizedDescription)
            }
            .map { $0.data }
            .decode(type: VenueResults.self, decoder: JSONDecoder())
            .map { $0.response.groups }
            .mapError { error in
                VenueListError.parsing(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.isFetching = false
                    self?.view?.didFailFetch(with: error)
                case .finished:
                    self?.isFetching = false
                    break
                }
            }, receiveValue: { groups in
                DispatchQueue.main.async {[weak self] in
                    let items = groups.flatMap { $0.items }
                    self?.isFetching = false
                    self?.view?.didFetchData(with: items)
                }
            })
        
    }
    
}
