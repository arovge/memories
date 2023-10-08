public class LogService {
    public init() {}
    
    public func log(info: String) {
        print("INFO: \(info)")
    }
    
    public func log(warning: String) {
        print("WARNING: \(warning)")
    }
    
    public func log(error: String) {
        print("ERROR: \(error)")
    }
    
    public func log(_ error: Error) {
        print("ERROR: \(error)")
    }
}
