
import XCTest

class PageBasedAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()
        XCUIDevice.sharedDevice().orientation = .Portrait
    }
    
    func testCollectionViewClickOnPageViewControllerReaction() {
        let collectionViewsQuery = XCUIApplication().collectionViews
        
        collectionViewsQuery.staticTexts["February"].swipeLeft()

        let augustButton = collectionViewsQuery.staticTexts["August"]
        expectationForPredicate(NSPredicate(format: "exists == YES"), evaluatedWithObject: augustButton, handler: nil)
        waitForExpectationsWithTimeout(2, handler: nil)
        augustButton.swipeLeft()

        let decemberButton = collectionViewsQuery.staticTexts["December"]
        expectationForPredicate(NSPredicate(format: "exists == YES"), evaluatedWithObject: decemberButton, handler: nil)
        waitForExpectationsWithTimeout(2, handler: nil)
        
        // MARK: Test that the "December" pagedViewController exists after scrolling & tapping on "December" collectionViewCell
        
        decemberButton.tap()
        let decemberLabel = XCUIApplication().otherElements.containingType(.NavigationBar, identifier:"Interact").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).staticTexts["December"]
        XCTAssert(decemberLabel.exists)
        
        // MARK: Test that the "October" pagedViewController exists after scrolling / tapping on "October" collectionViewCell
        
        collectionViewsQuery.staticTexts["October"].tap()
        let octoberLabel = XCUIApplication().otherElements.containingType(.NavigationBar, identifier:"Interact").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).staticTexts["October"]
        XCTAssert(octoberLabel.exists)
        
        // MARK: Test that the "November" pagedViewController exists after tapping on "November" collectionViewCell
        
        collectionViewsQuery.staticTexts["November"].tap()
        let novemberLabel = XCUIApplication().otherElements.containingType(.NavigationBar, identifier:"Interact").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).staticTexts["November"]
        XCTAssert(novemberLabel.exists)
        
        // MARK: Test that the "December" pagedViewController does not exist anymore (even on pageControl cache)
        
        XCTAssert(!decemberLabel.exists)
    }

    func testPageViewControllerSwipeOnCollectionViewReaction() {
        let januaryLabel = XCUIApplication().otherElements.containingType(.NavigationBar, identifier:"Interact").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).staticTexts["January"]
        januaryLabel.swipeLeft()
        
        // MARK: Test that "February" viewContyroller exists after a left swipe on "January" viewController
        
        let februaryLabel = XCUIApplication().otherElements.containingType(.NavigationBar, identifier:"Interact").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).staticTexts["February"]
        XCTAssert(februaryLabel.exists)

        // MARK: Test that "March" viewContyroller exists after a left swipe on "February" viewController
        // MARK: Test that "January" viewContyroller does not exist anymore (even on pageControl cache)
        
        februaryLabel.swipeLeft()
        let marchLabel = XCUIApplication().otherElements.containingType(.NavigationBar, identifier:"Interact").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).staticTexts["March"]
        XCTAssert(marchLabel.exists)
        XCTAssert(!januaryLabel.exists)
    }
    
    func testPageViewControllerClickOnPageIndicators() {
        let indicator = XCUIApplication().pageIndicators["page 1 of 12"]
        indicator.tap()
        expectationForPredicate(NSPredicate(format: "exists == false"), evaluatedWithObject: indicator, handler: nil)
        waitForExpectationsWithTimeout(30, handler: nil)
        XCUIDevice.sharedDevice().orientation = .Portrait
        XCUIApplication().pageIndicators["page 1 of 12"].tap()
    }
    
}
