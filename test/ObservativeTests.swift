import XCTest
@testable import Observative

class ObservativeTests: XCTestCase
{
    func testObserve()
    {
        var updateCalled = false
        let objectToWatch = NSMutableDictionary(dictionary:["key1":"value1", "key2":"value2"])
        
        let observative = Observative()
        observative.observe(objectToWatch, keyPath:"key1")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        XCTAssertFalse(updateCalled)
        objectToWatch["key1"] = "updatedValue1"
        XCTAssert(updateCalled)
    }
    
    func testStopObserving()
    {
        var updateCalled = false
        let objectToWatch = NSMutableDictionary(dictionary:["key1":"value1", "key2":"value2"])
        
        let observative = Observative()
        observative.observe(objectToWatch, keyPath:"key1")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        XCTAssertFalse(updateCalled)
        observative.stopObserving()
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
        observative.observe(objectToWatch, keyPath:"property")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        objectToWatch.property = "new"

        XCTAssertFalse(updateCalled)
        observative.stopObserving()
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
        observative.observe(objectToWatch, keyPath:"property")
        { (oldValue, newValue) in
            updateCalled = true
        }
        
        objectToWatch.property = "new"

        XCTAssertTrue(updateCalled)
        observative.stopObserving()
    }
}
