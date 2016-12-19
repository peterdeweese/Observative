# Observatory
Swift library to simplify key value observation. KVO only works with NSObjects, so Observatory can only observe ancestors of NSObject.

### Types
 * public typealias UpdateBlock = (_ oldValue:Any?, _ newValue:Any?) -> Void

### Methods
 * func startObservation(of object:NSObject, keyPath:String, update:UpdateBlock?)
 * func stopObservation(of object:NSObject, keyPath:String)
 * func stopObservation(of object:NSObject)
 * func stopObservation()

### Playground Example
```swift
var updateCalled = false
let objectToWatch = NSMutableDictionary(dictionary:["key1":"value1"])
        
let observatory = Observatory()
observatory.startObservation(objectToWatch, keyPath:"key1")
{ (oldValue, newValue) in
    updateCalled = true
}
        
objectToWatch["key1"] = "updatedValue1"
if updateCalled{ print("it worked!") }
```

### Class Example
```swift
class MyController
{
    let observatory = Observatory()

    var objectToWatch:CustomObject {
        didSet {
            if oldValue != nil
            {
                observatory.stopObservation(oldValue, keyPath: "myProperty")
            }
            observatory.startObservation(objectToWatch, keyPath:"myProperty")
            { oldValue, newValue in
                self.doOnChange()
            }
        }
    }
    
    func doOnChange()
    {
        // object changed
    }
}
```