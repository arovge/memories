import SwiftUI

enum Route {
    case dashboard
    case settings
}

@Observable
class Navigator {
    var path = [Route.dashboard]
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func back() {
        guard path.count > 1 else { return }
        _ = path.popLast()
    }
}
