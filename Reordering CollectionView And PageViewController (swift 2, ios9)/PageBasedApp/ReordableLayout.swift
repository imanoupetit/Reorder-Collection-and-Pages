
import UIKit

class ReordableLayout: UICollectionViewFlowLayout {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        minimumInteritemSpacing = 10
        minimumLineSpacing = 0
        itemSize = CGSize(width: 100, height: 100)
        scrollDirection = .Horizontal
    }

    @available(iOS 9, *)
    override func layoutAttributesForInteractivelyMovingItemAtIndexPath(indexPath: NSIndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        // Set the layout attributes when moving a cell (we want to scale it to 1.1)
        let attributes = super.layoutAttributesForInteractivelyMovingItemAtIndexPath(indexPath, withTargetPosition: position)
        attributes.transform = CGAffineTransformMakeScale(Constants.cellTransformUnit, Constants.cellTransformUnit)
        return attributes
    }
        
}
