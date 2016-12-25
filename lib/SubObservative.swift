import Foundation

class SubObservative:NSObject
{
    private var observations = Observations()
    
    private func observe(_ observation:Observation)
    {
        guard let object = observation.object else
        {
            return
        }
        
        if let oldObservation = observations[object, observation.keyPath]
        {
            stopObserving(oldObservation)
        }
        
        _ = observations.insert(observation)
        observation.object?.addObserver(self, forKeyPath:observation.keyPath, options:[.old, .new], context: nil)
    }
    
    public func observe(_ object:NSObject,
                        keyPath:String,
                        oldNewKeyFunction:OldNewKeyFunction? = nil,
                        newKeyFunction:NewKeyFunction? = nil,
                        keyChangedFunction:KeyChangedFunction? = nil)
    {
        observe(Observation(object:object,
                            keyPath:keyPath,
                            oldNewKeyFunction:oldNewKeyFunction,
                            newKeyFunction:newKeyFunction,
                            keyChangedFunction:keyChangedFunction))
    }
    
    private func stopObserving(_ observation:Observation)
    {
        observations.remove(observation)
        if let object = observation.object
        {
            object.removeObserver(self, forKeyPath: observation.keyPath)
        }
    }
    
    public func stopObserving(_ object:NSObject, keyPath:String)
    {
        if let observation = observations[object, keyPath]
        {
            stopObserving(observation)
        }
    }
    
    public func stopObserving(_ object:NSObject)
    {
        observations[object]?.values.forEach{ stopObserving($0) }
    }
    
    public func stopObserving()
    {
        observations.set.forEach{ stopObserving($0) }
    }
    
    //If this isn't called, the observed property might need to be declared as `dynamic`
    override public func observeValue(forKeyPath keyPath:String?, of object:Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let object = object as? NSObject,
            let keyPath = keyPath,
            let observation = observations[object, keyPath]
        {
            //TODO update for indexes
            observation.oldNewKeyFunction?(change?[.oldKey], change?[.newKey])
            observation.newKeyFunction?(change?[.newKey])
            observation.keyChangedFunction?()
        }
    }
    
    deinit
    {
        stopObserving()
    }
    
    private class Observations
    {
        subscript(object:NSObject)->[String:Observation]? {
            get { return byObjectAndKeyPath[object] }
        }
        
        subscript(object:NSObject, keyPath:String)->Observation?
            {
            get { return byObjectAndKeyPath[object]?[keyPath] }
        }
        
        var set = Set<Observation>()
        private var byObjectAndKeyPath = [NSObject:[String:Observation]]()
        
        func insert(_ observation:Observation) -> Bool //success
        {
            guard let object = observation.object else
            {
                return false
            }
            
            if self[object, observation.keyPath] != nil
            {
                return false
            }
            
            if self[object] == nil
            {
                byObjectAndKeyPath[object] = [String:Observation]()
            }
            
            byObjectAndKeyPath[object]?[observation.keyPath] = observation
            set.insert(observation)
            return true
        }
        
        func remove(_ observation:Observation)
        {
            //TODO: find it even if the object has become nil
            guard let object = observation.object else
            {
                return
            }
            set.remove(observation)
            byObjectAndKeyPath[object]?[observation.keyPath] = nil
        }
    }
}
