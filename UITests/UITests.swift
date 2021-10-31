import XCTest

class UITests: XCTestCase {

    let application = XCUIApplication()
    let timeout: TimeInterval = 6.0
    
    func test_dataLoaded() {
        application.launch()
        
        addUIInterruptionMonitor(withDescription: "Location") { alert -> Bool in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
        application.tap()
        
        let searchButton = application.buttons["search"].firstMatch
        XCTAssertTrue(searchButton.waitForExistence(timeout: timeout))
        searchButton.tap()
        
        let collectionView = application.collectionViews["collectionView"].firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: timeout))
        
        let pictureHouseCell = collectionView.cells["55abb677498e486cda8e2ef7"].firstMatch
        
        let pictureHousePredicate = NSPredicate(format: "label CONTAINS[cd] 'picturehouse central'")
        XCTAssertTrue(pictureHouseCell.staticTexts.matching(pictureHousePredicate).firstMatch.exists)
        
        let categoryPredicate = NSPredicate(format: "label CONTAINS[cd] 'Cafeteria'")
        XCTAssertTrue(pictureHouseCell.staticTexts.matching(categoryPredicate).firstMatch.exists)
        
        let addressPredicate = NSPredicate(format: "label CONTAINS[cd] 'Shaftesbury Avenue'")
        XCTAssertTrue(pictureHouseCell.staticTexts.matching(addressPredicate).firstMatch.exists)
        
        let distancePredicate = NSPredicate(format: "label CONTAINS[cd] '0.05m'")
        XCTAssertTrue(pictureHouseCell.staticTexts.matching(distancePredicate).firstMatch.exists)
    }
}
