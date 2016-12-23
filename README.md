# Observative
Swift library to simplify key value observation. KVO only works with NSObjects, so Observative can only observe ancestors of NSObject.
 * Observe properties only on NSObjects
 * Declare observed properties dynamic, `dynamic var myVar`

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
        
let observative = Observative()
observative.startObservation(objectToWatch, keyPath:"key1")
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
    let observative = Observative()

    var objectToWatch:CustomObject {
        didSet {
            if oldValue != nil
            {
                observative.stopObservation(oldValue, keyPath: "myProperty")
            }
            observative.startObservation(objectToWatch, keyPath:"myProperty")
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
