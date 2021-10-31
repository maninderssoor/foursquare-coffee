import CoreLocation
import Foundation
import UIKit

class VenueListViewController: UIViewController {
    
    private let viewModel: VenueListViewModel
    
    private lazy var datasource: UICollectionViewDiffableDataSource<VenueSection, VenueItem>? = {
        guard let collectionView = self.collectionView else { return nil }
        
        return UICollectionViewDiffableDataSource<VenueSection, VenueItem>(collectionView: collectionView) { collectionView, IndexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VenueCell.identifier, for: IndexPath) as? VenueCell else { return nil }
            
            cell.accessibilityIdentifier = item.venue.id
            cell.labelTitle?.text = item.venue.name
            cell.labelSubheading?.text = item.venue.formattedCategories
            cell.labelDescription?.text = item.venue.location.formattedAddress
            cell.labelDistance?.text = item.venue.location.formattedDistance
            
            return cell
        }
    }()
    
    private lazy var flowLayout: UICollectionViewLayout = {
        UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            return VenueListLayoutManager.item
        }
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        
        return manager
    }()
    
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var startSearchView: UIView?
    
    private lazy var startSearchTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(loadData))
        return gesture
    }()
    
    init(viewModel: VenueListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = VenueListViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        viewModel.view = self
        
        startSearchView?.addGestureRecognizer(startSearchTapGesture)
    }
}

extension VenueListViewController {
    
    private func setupCollectionView() {
        collectionView?.register(UINib(nibName: VenueCell.xib, bundle: nil), forCellWithReuseIdentifier: VenueCell.identifier)
        collectionView?.collectionViewLayout = flowLayout
        collectionView?.accessibilityIdentifier = "collectionView"
    }
    
    private func setPlaceholderVisiblity(isVisible visible: Bool) {
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.startSearchView?.alpha = visible ? 1.0 : 0.0
            self?.collectionView?.alpha = visible ? 0.0 : 1.0
        }
    }
    
    @IBAction func loadData() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            UIAlertController.controller(with: NSLocalizedString("Error", comment: ""),
                                         and: NSLocalizedString("Please open sample in iOS Settings and enable location services", comment: ""),
                                         on: self)
        default:
            locationManager.startUpdatingLocation()
        }
        
    }
}

extension VenueListViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedAlways ||
                manager.authorizationStatus == .authorizedWhenInUse else { return }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        setPlaceholderVisiblity(isVisible: false)
        viewModel.fetchData(with: location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get the users location with error \(String(describing: error))")
        locationManager.stopUpdatingLocation()
    }
}


extension VenueListViewController: VenueListView {
    func didFetchData(with items: [VenueItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<VenueSection, VenueItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        self.datasource?.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func didFailFetch(with error: VenueListError) {
        print("Failed to fetch Items \(String(describing: error))")
        
        setPlaceholderVisiblity(isVisible: true)
        UIAlertController.controller(with: NSLocalizedString("Error", comment: ""),
                                     and: NSLocalizedString("Couldn't fetch results", comment: ""),
                                     on: self)
    }
    
}

protocol VenueListView: AnyObject {
    func didFetchData(with items: [VenueItem])
    func didFailFetch(with error: VenueListError)
}

private extension CGFloat {
    static let scrollViewPrefetchInset: CGFloat = 300.0
}

private extension Int {
    static let initialPaginatedPageIndex: Int = 2
}

