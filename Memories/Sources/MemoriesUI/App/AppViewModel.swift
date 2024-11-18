import SwiftUI
import MemoriesServices

@Observable
class AppViewModel {
    private let photosService: PhotosService = PhotosService()
    private var loaded = false
    
    var hasPhotosAccess = false
    var loading = true
    
    func handleAppear(isFromSceneChange: Bool = false, _ navigator: Navigator) async {
        guard !loaded || isFromSceneChange else { return }
        loaded = true
        
        let result = await photosService.requestAccess()
        
        // TODO: Handle more cases and prompt for access if notDetermined
        if result == .authorized {
            hasPhotosAccess = true
        } else {
            hasPhotosAccess = false
        }
        loading = false
    }
}
