import Foundation
import UIKit

class VenueCell: UICollectionViewCell {
    
    static let xib = "VenueCell"
    static let identifier = "VenueCellIdentifier"
    
    @IBOutlet weak var labelTitle: UILabel?
    @IBOutlet weak var labelSubheading: UILabel?
    @IBOutlet weak var labelDescription: UILabel?
    
    @IBOutlet weak var labelDistance: UILabel?
}
