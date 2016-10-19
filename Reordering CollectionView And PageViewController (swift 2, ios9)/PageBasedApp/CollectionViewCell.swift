
import UIKit

class CollectionViewCell: UICollectionViewCell, WiggleProtocol, AnimateProtocol {
    
    @IBOutlet weak var label: UILabel!

    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set the cell's borderColor
        contentView.layer.borderColor = UIColor.orangeColor().CGColor
    }
    
    /**
     Toggle border width.
     - Parameter state: A `Bool` indicating if we should display or not the border.
     */
    func setCellSelectedState(state: Bool) {
        contentView.layer.borderWidth = state ? 10 : 0
    }
    
}
