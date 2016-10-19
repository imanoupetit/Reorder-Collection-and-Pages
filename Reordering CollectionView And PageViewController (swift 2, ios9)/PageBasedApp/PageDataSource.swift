
import UIKit

private let identifier = "DataViewController"

class PageDataSource: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let model: Model
    let updateCollectionView: () -> Void
    
    // MARK: Initializer

    init(model: Model, updateCollectionView: () -> Void) {
        self.model = model
        self.updateCollectionView = updateCollectionView
        super.init()
    }
    
    // MARK: Custom methods
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Early exit if pageData.count is 0 or if index is out of bounds
        if !model.array.indices.contains(index) { return nil }
        
        // Create a new view controller and pass suitable data
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as! DataViewController
        dataViewController.dataObject = model.array[index]
        return dataViewController
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! DataViewController
        guard let index = model.array.indexOf(vc.dataObject), let storyboard = viewController.storyboard else { return nil }
        return viewControllerAtIndex(index - 1, storyboard: storyboard)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! DataViewController
        guard let index = model.array.indexOf(vc.dataObject), let storyboard = viewController.storyboard else { return nil }
        return viewControllerAtIndex(index + 1, storyboard: storyboard)
    }
    
    // MARK: UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // completed property indicates when swipe is terminated (and not aborted)
        if let vc = pageViewController.viewControllers?.last as? DataViewController, let index = model.array.indexOf(vc.dataObject) where completed {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)

            // Update model
            model.selectedIndexPath = indexPath

            // Update the collectionView with the new index
            updateCollectionView()
        }
    }
    
}
