import Foundation

//TODO: add conventional method extensions?
public class Observative:NSObject
{
    public typealias UpdateBlock = (_ oldValue:Any?, _ newValue:Any?) -> Void

    var observations = Observations()
    
    private func startObservation(_ observation:Observation)
    {
        guard let object = observation.object else
        {
            return
        }

        if let oldObservation = observations[object, observation.keyPath]
        {
            stopObservation(oldObservation)
        }
    
        _ = observations.insert(observation)
        observation.object?.addObserver(self, forKeyPath:observation.keyPath, options:[.old, .new], context: nil)
    }
    
    func startObservation(of object:NSObject, keyPath:String, update:UpdateBlock?)
    {
        startObservation(Observation(object:object, keyPath:keyPath, update:update))
    }

    private func stopObservation(_ observation:Observation)
    {
        observations.remove(observation)
        if let object = observation.object
        {
            object.removeObserver(self, forKeyPath: observation.keyPath)
        }
    }
    
    func stopObservation(of object:NSObject, keyPath:String)
    {
        if let observation = observations[object, keyPath]
        {
            stopObservation(observation)
        }
    }

    func stopObservation(of object:NSObject)
    {
        observations[object]?.values.forEach{ stopObservation($0) }
    }
    
    func stopObservation()
    {
        observations.set.forEach{ stopObservation($0) }
    }
    
    override public func observeValue(forKeyPath keyPath:String?, of object:Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let object = object as? NSObject,
            let keyPath = keyPath,
            let observation = observations[object, keyPath]
        {
            //TODO update for indexes
            observation.update?(change?[.oldKey], change?[.newKey])
        }
    }
    
    deinit
    {
        stopObservation()
    }
    
    //TODO: make public and make object and keypath read only
    class Observation:NSObject
    {
        weak var object:NSObject?
        var keyPath:String

        var update:UpdateBlock?

        required init(object:NSObject, keyPath:String, update:UpdateBlock? = nil)
        {
            self.object = object
            self.keyPath = keyPath
            self.update = update
        }
    }

    class Observations
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
