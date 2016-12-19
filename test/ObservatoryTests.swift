import XCTest
@testable import Observative

class ObservatoryTests: XCTestCase
{
    func testObservation()
    {
        var updateCalled = false
        let objectToWatch = NSMutableDictionary(dictionary:["key1":"value1", "key2":"value2"])
        
        let observatory = Observatory()
        observatory.startObservation(of:objectToWatch, keyPath:"key1")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        XCTAssertNotNil(observatory.observations[objectToWatch, "key1"])
        XCTAssertFalse(updateCalled)
        objectToWatch["key1"] = "updatedValue1"
        XCTAssert(updateCalled)
    }
    
    func testStopObservations()
    {
        var updateCalled = false
        let objectToWatch = NSMutableDictionary(dictionary:["key1":"value1", "key2":"value2"])
        
        let observatory = Observatory()
        observatory.startObservation(of:objectToWatch, keyPath:"key1")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        XCTAssertNotNil(observatory.observations[objectToWatch, "key1"])
        XCTAssertFalse(updateCalled)
        
        observatory.stopObservation()

        objectToWatch["key1"] = "updatedValue1"
        XCTAssertFalse(updateCalled)
    }
}
