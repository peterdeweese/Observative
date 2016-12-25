import Foundation

public typealias OldNewKeyFunction = (_ oldValue:Any?, _ newValue:Any?) -> Void
public typealias NewKeyFunction = (_ newValue:Any?) -> Void
public typealias KeyChangedFunction = () -> Void

//TODO: add conventional method extensions?
//TODO: watch for weak objects to be released
public class Observative: Observes
{
    //See `Observes` protocol
}
