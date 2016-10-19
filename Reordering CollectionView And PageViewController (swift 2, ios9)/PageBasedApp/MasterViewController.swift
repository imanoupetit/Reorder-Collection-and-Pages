
import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let model = Model()
    var collectionDataSource: CollectionDataSource!
    var pageDataSource: PageDataSource!
    lazy var gesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
    }()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a closure to update the pageViewController when we tap a cell in collectionView
        let resetPageViewController = { [unowned self] (index: Int, direction: UIPageViewControllerNavigationDirection) in
            if let pageViewController = self.childViewControllers.first as? PageViewController, pagedViewController = self.pageDataSource.viewControllerAtIndex(index, storyboard: self.storyboard!) {
                pageViewController.setViewControllers([pagedViewController], direction: direction, animated: true, completion: nil)
            }
        }
        
        // Create a closure to make a new cell appears on screen wiggle or not according to controller's editing state
        let isEditing = { [unowned self] in self.editing }
        
        // Init collectionDataSource
        collectionDataSource = CollectionDataSource(model: model, resetPageViewController: resetPageViewController, isEditing: isEditing)
        
        // Once collectionDataSource is initialized, set it as data source and delegate for collection view
        collectionView.dataSource = collectionDataSource
        collectionView.delegate = collectionDataSource
        
        // Add gesture to collectionView in order to allow reordering collectionView cells
        collectionView.addGestureRecognizer(gesture)

        // Set first selected cell to kick things off
        let indexPath = collectionDataSource.model.selectedIndexPath
        self.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass a closure to page view controller data source: when swipe is finished on a page, update the collectionView accordingly
        let updateCollectionView = { [unowned self] in
            // Manually select and center the cell at indexPath
            self.collectionView.selectItemAtIndexPath(self.model.selectedIndexPath, animated: true, scrollPosition: .CenteredHorizontally)
            
            // Manually toggle the borders of the visible cells
            for indexPath in self.collectionView.indexPathsForVisibleItems() {
                let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
                cell.setCellSelectedState(indexPath == self.model.selectedIndexPath)
            }
        }
        pageDataSource = PageDataSource(model: model, updateCollectionView: updateCollectionView)

        // Before to display the container embedding the pageViewController, we need to initialize the pageViewController
        let controller = segue.destinationViewController as! PageViewController
        controller.pageDataSource = pageDataSource
    }
    
    
    // MARK: - Editing
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Update display for visible cells when editing state changes
        for cell in collectionView.visibleCells() as! [CollectionViewCell] {
            cell.toggleWigglingFromState(editing)
        }
    }
    
}

extension MasterViewController: ReorderProtocol {
    
    // - MARK: Gesture management
    
    /**
     This method must be `internal` (not `private`) in order to be exposed to Objective-C's `#selector`
     */
    func longPressed(gesture: UILongPressGestureRecognizer) {
        let location = gesture.locationInView(collectionView)
        
        switch gesture.state {
        case .Began:
            handleBeganState(withLocation: location)
        case .Changed:
            handleChangedState(withLocation: location)
        case .Ended:
            handleEndedState(withLocation: location)
        default:
            handleCancelledState(withLocation: location)
        }
    }
    
}
