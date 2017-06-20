import CoreMotion

/// Forwards gyro data.
public protocol AEMotionDelegate: class {
    /// Every gyro update is forwared to `delegate` through this method.
    func didUpdate(gyroData: CMGyroData)
}

/**
    Simple subclass of `CMMotionManager` which sends gyro updates
    to its `delegate` and can be toggled ON and OFF.
*/
open class AEMotion: CMMotionManager {
    
    // MARK: - Properties
    
    /// Set delegate to receive gyro data.
    open weak var delegate: AEMotionDelegate?
    
    /// Defines if gyro updates are enabled or not. Defaults to `false`.
    open var isEnabled = false {
        didSet {
            if isEnabled != oldValue {
                isEnabled ? startTrackingMotion() : stopTrackingMotion()
            }
        }
    }
    
    // MARK: - API
    
    /// Toggles gyro updates ON and OFF.
    open func toggle() {
        isEnabled = !isEnabled
    }
    
    // MARK: - Helpers
    
    private func startTrackingMotion() {
        guard
            let queue = OperationQueue.current,
            isGyroAvailable,
            isGyroActive == false
        else { return }
        
        startGyroUpdates(to: queue, withHandler: { (gyroData, NSError) in
            guard let data = gyroData else { return }
            self.delegate?.didUpdate(gyroData: data)
        })
    }
    
    private func stopTrackingMotion() {
        stopGyroUpdates()
    }
    
}
