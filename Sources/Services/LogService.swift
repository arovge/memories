class LogService {
    func log(info: String) {
        print("INFO: \(info)")
    }
    
    func log(warning: String) {
        print("WARNING: \(warning)")
    }
    
    func log(error: String) {
        print("ERROR: \(error)")
    }
    
    func log(_ error: Error) {
        print("ERROR: \(error)")
    }
}
