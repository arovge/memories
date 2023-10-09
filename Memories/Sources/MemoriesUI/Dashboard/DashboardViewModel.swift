import SwiftUI
import MemoriesModels
import MemoriesServices
import MemoriesUtility

@Observable
class DashboardViewModel {
    var memorySections: [MemorySection] = []
    var layout: ColumnLayout = .single
    var showSettingsSheet: Bool = false
    var loading: Bool = true
    var error: Bool = false
    var hasPhotosAccess: Bool = false
    
    // TODO: use new formatted api
    let currentMonthAndDay: String = Date().formatted("MMMM d")
    private var requestedMedia: [MediaWrapper] = []
    private let photosService: PhotosService = PhotosService()
    private let logger = Logger()
    private var loaded: Bool = false
    
    func handleAppear() async {
        if loaded { return }
        loaded = true
        
        let result = await photosService.requestAccess()
        
        if result == .authorized {
            hasPhotosAccess = true
            fetchPhotos()
        } else {
            hasPhotosAccess = false
        }
    }
    
    func fetchPhotos() {
        photosService.fetchMedia(addMedia: self.addMedia)
        let sections = computeMemorySections()
        
        memorySections = sections
        loading = false
    }
    
    func computeMemorySections() -> [MemorySection] {
        let mediaGroupedByYear = self.requestedMedia.reduce(into: [:] as [Int: [MediaWrapper]]) { acc, media in
            let components = Calendar.current.dateComponents([.year], from: media.createdDate)
            guard let year = components.year else { return }
            acc[year, default: []].append(media)
        }
        
        return mediaGroupedByYear
            .map { key, values in
                MemorySection(year: key, memories: values.sorted(by: { $0.createdDate > $1.createdDate }))
            }
            .sorted(by: { $0.year > $1.year })
    }
    
    func addMedia(wrapper: MediaWrapper) {
        self.requestedMedia.append(wrapper)
    }
    
    func toggleLayout() {
        layout = layout.next()
    }
    
    func viewMediaInPhotos() {
        
    }
    
    func sendNotification() {
        var date = DateComponents()
        // 8am
        date.hour = 8
        date.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request: UNNotificationRequest = .init(
            identifier: "Shaba",
            content: .init(),
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                self.logger.log(error)
            } else {
                self.logger.info("Notification sent")
            }
        })
    }
    
    func share(year: Int, media: MediaWrapper) {
        let text = "My memory from \(currentMonthAndDay), \(year)"
        let itemSource = ActivityItemSource(text: text, image: media.placeholderImage)
        let activityController = UIActivityViewController(
            activityItems: [media.placeholderImage, text, itemSource],
            applicationActivities: nil
        )
        UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
}
