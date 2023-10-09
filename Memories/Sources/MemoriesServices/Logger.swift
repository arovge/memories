public class Logger {
    public init() {}
    
    public func info(_ value: String) {
        print("INFO: \(value)")
    }
    
    public func warning(_ value: String) {
        print("WARNING: \(value)")
    }
    
    public func error(_ value: String) {
        print("ERROR: \(value)")
    }
    
    public func log(_ error: any Error) {
        print("ERROR: \(error)")
    }
}
