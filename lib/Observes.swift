import Foundation

// Enhanced observation
public protocol Observes
{
    func observe(_ object:NSObject, keyPath:String, onChange:@escaping OldNewKeyFunction)
    func observe(_ object:NSObject, keyPath:String, onChange:@escaping NewKeyFunction)
    func observe(_ object:NSObject, keyPath:String, onChange:@escaping KeyChangedFunction)
    func stopObserving(_ object:NSObject, keyPath:String)
    func stopObserving(_ object:NSObject)
    func stopObserving()
}

private var ObservesObservativeKey: UInt8 = 0

//Proxies to SubObservative to take advantage of swift type selectors in method names here and KVO there.
public extension Observes
{
    private func getObservative() -> SubObservative?
    {
        return objc_getAssociatedObject(self, &ObservesObservativeKey) as? SubObservative
    }

    private var observative:SubObservative {
        if getObservative() == nil
        {
            objc_setAssociatedObject(self, &ObservesObservativeKey, SubObservative(), .OBJC_ASSOCIATION_RETAIN)
        }
        return getObservative()!
    }
    
    public func observe(_ object:NSObject, keyPath:String, onChange:@escaping OldNewKeyFunction)
    {
        observative.observe(object, keyPath:keyPath, oldNewKeyFunction:onChange)
    }
    
    public func observe(_ object:NSObject, keyPath:String, onChange:@escaping NewKeyFunction)
    {
        observative.observe(object, keyPath:keyPath, newKeyFunction:onChange)
    }
    
    public func observe(_ object:NSObject, keyPath:String, onChange:@escaping KeyChangedFunction)
    {
        observative.observe(object, keyPath:keyPath, keyChangedFunction:onChange)
    }
    
    public func stopObserving(_ object:NSObject, keyPath:String)
    {
        observative.stopObserving(object, keyPath:keyPath)
    }
    
    public func stopObserving(_ object:NSObject)
    {
        observative.stopObserving(object)
    }

    public func stopObserving()
    {
        observative.stopObserving()
    }
}
