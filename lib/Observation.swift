import Foundation

//TODO: make public and make object and keypath read only
public class Observation:NSObject
{
    weak var object:NSObject?
    var keyPath:String
    
    var oldNewKeyFunction:OldNewKeyFunction?
    var newKeyFunction:NewKeyFunction?
    var keyChangedFunction:KeyChangedFunction?

    public required init(object:NSObject,
                         keyPath:String,
                         oldNewKeyFunction:OldNewKeyFunction? = nil,
                         newKeyFunction:NewKeyFunction? = nil,
                         keyChangedFunction:KeyChangedFunction? = nil)
    {
        self.object = object
        self.keyPath = keyPath
        self.oldNewKeyFunction = oldNewKeyFunction
        self.newKeyFunction = newKeyFunction
        self.keyChangedFunction = keyChangedFunction
    }
}
