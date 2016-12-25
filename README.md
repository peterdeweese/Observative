# Observative
Swift library to simplify key value observation. KVO only works with NSObjects, so Observative can only observe ancestors of NSObject.
 * Observe properties only on NSObjects
 * Declare observed properties dynamic, `dynamic var myVar`

### Methods
* observe(_ object:NSObject, keyPath:String, onChange:*see below*)
	+ (_ oldValue:Any?, _ newValue:Any?) -> Void
	+ (_ newValue:Any?) -> Void
	+ () -> Void
* stopObserving(_ object:NSObject)
* stopObserving()

### Playground Example
```swift
var updateCalled = false
let objectToWatch = NSMutableDictionary(dictionary:["key1":"value1"])
        
let observative = Observative()
observative.observe(objectToWatch, keyPath:"key1")
{
    updateCalled = true
}
        
objectToWatch["key1"] = "updatedValue1"
if updateCalled{ print("it worked!") }
```

### Class Example
```swift
class MyController, Observes
{
    var objectToWatch:CustomObject {
        didSet {
            if oldValue != nil
            {
                stopObserving(oldValue)
            }
            observe(objectToWatch, keyPath:"myProperty")
            {
                self.doOnChange()
            }
        }
    }
    
    func doOnChange()
    {
    	print("myProperty changed!")
        // object changed
    }
}
```
