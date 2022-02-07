class LogService {
    func logInformation(_ info: String) {
        print("INFO: \(info)")
    }
    
    func logWarning(_ warning: String) {
        print("WARNING: \(warning)")
    }
    
    func logError(_ error: String) {
        print("ERROR: \(error)")
    }
    
    func logError(_ error: Error) {
        print("ERROR: \(error)")
    }
}
