import SwiftUI
import MemoriesModels
import MemoriesServices
import MemoriesUtility

class DashboardViewModel: ObservableObject {
    @Published var memorySections: [MemorySection] = []
    @Published var layout: ColumnLayout = .single
    @Published var showSettingsSheet: Bool = false
    @Published var loading: Bool = true
    @Published var error: Bool = false
    @Published var hasPhotosAccess: Bool = false
    let currentMonthAndDay: String = Date().toString(format: "MMMM d")
    private var requestedMedia: [MediaWrapper] = []
    private let photosService: PhotosService = PhotosService()
    private let logService: LogService = LogService()
    private var loaded: Bool = false
    
    func handleAppear() {
        if loaded { return }
        loaded = true
        
        photosService.requestAccess { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async { self.hasPhotosAccess = true }
                self.fetchPhotos()
            default:
                self.hasPhotosAccess = false
            }
        }
    }
    
    func fetchPhotos() {
        photosService.fetchMedia(addMedia: self.addMedia)
        let sections = computeMemorySections()
        
        DispatchQueue.main.async {
            self.memorySections = sections
            self.loading = false
        }
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
        DispatchQueue.main.async { self.requestedMedia.append(wrapper) }
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
                self.logService.log(error)
            } else {
                self.logService.log(info: "Notification sent")
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
