import XCTest
@testable import Observative

class ObservativeTests: XCTestCase
{
    func testObservation()
    {
        var updateCalled = false
        let objectToWatch = NSMutableDictionary(dictionary:["key1":"value1", "key2":"value2"])
        
        let observative = Observative()
        observative.startObservation(of:objectToWatch, keyPath:"key1")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        XCTAssertNotNil(observative.observations[objectToWatch, "key1"])
        XCTAssertFalse(updateCalled)
        objectToWatch["key1"] = "updatedValue1"
        XCTAssert(updateCalled)
    }
    
    func testStopObservations()
    {
        var updateCalled = false
        let objectToWatch = NSMutableDictionary(dictionary:["key1":"value1", "key2":"value2"])
        
        let observative = Observative()
        observative.startObservation(of:objectToWatch, keyPath:"key1")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        XCTAssertNotNil(observative.observations[objectToWatch, "key1"])
        XCTAssertFalse(updateCalled)
        
        observative.stopObservation()
        
        objectToWatch["key1"] = "updatedValue1"
        XCTAssertFalse(updateCalled)
    }
    
    class TestClass:NSObject
    {
        var property = "test"
    }

    func testFailureWithoutDynamicProperties()
    {
        var updateCalled = false
        let objectToWatch = TestClass()
        
        let observative = Observative()
        observative.startObservation(of:objectToWatch, keyPath:"property")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        objectToWatch.property = "new"

        XCTAssertFalse(updateCalled)
        observative.stopObservation()
    }
    
    class TestClass2:NSObject
    {
        dynamic var property = "test"
    }
    
    func testSuccessWithDynamicProperties()
    {
        var updateCalled = false
        let objectToWatch = TestClass2()
        
        let observative = Observative()
        observative.startObservation(of:objectToWatch, keyPath:"property")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        objectToWatch.property = "new"

        XCTAssertTrue(updateCalled)
        observative.stopObservation()
    }
}
