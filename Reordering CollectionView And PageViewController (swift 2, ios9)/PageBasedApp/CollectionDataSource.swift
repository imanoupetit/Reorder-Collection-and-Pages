
import UIKit

private let reuseIdentifier = "Cell"

class CollectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let model: Model
    let resetPageViewController: (withIndex: Int, direction: UIPageViewControllerNavigationDirection) -> Void
    let isEditing: () -> Bool

    // - MARK: - Initializer
    
    init(model: Model, resetPageViewController: (withIndex: Int, direction: UIPageViewControllerNavigationDirection) -> Void, isEditing: () -> Bool) {
        self.model = model
        self.resetPageViewController = resetPageViewController
        self.isEditing = isEditing
        super.init()
    }
    
    // - MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        // Set display for cell
        cell.label.text = model.array[indexPath.row]
        cell.setCellSelectedState(indexPath == model.selectedIndexPath)

        // Set wiggle according to viewController's editing state
        cell.toggleWigglingFromState(isEditing())
        
        return cell
    }
    
    @available(iOS 9, *)
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        // Update the model while moving cells
        let movingItem = model.array.removeAtIndex(sourceIndexPath.item)
        model.array.insert(movingItem, atIndex: destinationIndexPath.item)
    }
    
    // - MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // When cell is selected, force pageViewController to present the page associated with the new indexPath
        switch model.selectedIndexPath.compare(indexPath) {
        case .OrderedAscending:
            resetPageViewController(withIndex: indexPath.row, direction: .Forward)
        case .OrderedDescending:
            resetPageViewController(withIndex: indexPath.row, direction: .Reverse)
        case .OrderedSame:
            break
        }

        // Update model
        model.selectedIndexPath = indexPath
        
        // Center the cell to be selected
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
        
        // Update the selected state of the cell when tapping on it
        // Note: It does not call this method when you programmatically set the selection
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell
        cell?.setCellSelectedState(true)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        // Update the selected state of the cell when it is no more selected
        // Note: It does not call this method when you programmatically set the selection
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell
        cell?.setCellSelectedState(false)
    }

}
