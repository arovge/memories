import SwiftUI

@Observable
class Navigator: ObservableObject {
    var path = [Route.dashboard]
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func back() {
        guard path.count > 1 else { return }
        _ = path.popLast()
    }
}
