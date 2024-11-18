import SwiftUI
import MemoriesServices

@Observable
class AppViewModel {
    private let photosService: PhotosService = PhotosService()
    var loading = true
    
    var hasPhotosAccess = false
    
    func handleAppear(_ navigator: Navigator) async {
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
