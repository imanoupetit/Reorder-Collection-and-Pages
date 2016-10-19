
import UIKit

class PageViewController: UIPageViewController {
    
    var pageDataSource: PageDataSource!

    required init?(coder: NSCoder) {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: 5])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .groupTableViewBackgroundColor()
        dataSource = pageDataSource
        delegate = pageDataSource

        // Set first selected page to kick things off
        let index = pageDataSource.model.selectedIndexPath.row
        if let startingViewController = pageDataSource.viewControllerAtIndex(index, storyboard: storyboard!) {
            setViewControllers([startingViewController], direction: .Forward, animated: false, completion: nil)
        }
    }
    
}
