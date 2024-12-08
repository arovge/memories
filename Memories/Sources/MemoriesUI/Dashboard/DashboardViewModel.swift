import SwiftUI
import MemoriesModels
import MemoriesServices
import Photos

@Observable
class DashboardViewModel {
    var layout = ColumnLayout.triple
    var loading = true
    var hasPhotosAccess = false
    var error = false
    var mediaSections = [MediaSection]()
    
    let currentMonthAndDay = Date
        .now
        .formatted(
            .dateTime
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.defaultDigits)
        )
    
    private var assets = PHFetchResult<PHAsset>()
    private let photosService = PhotosService()
    private let logger = Logger()
    private var loaded = false
    
    var hasMemories: Bool {
        !mediaSections.isEmpty
    }
    
    func handleAppear(force: Bool = false) async {
        guard !loaded || force || !hasPhotosAccess else { return }
        loaded = true
        defer { loading = false }
        
        await checkPhotosAccess()
        guard hasPhotosAccess else { return }
        
        assets = photosService.getAssets()
        mediaSections = groupMedia()
    }
    
    func checkPhotosAccess() async {
        let result = await photosService.requestAccess()
                
        hasPhotosAccess = switch result {
        case .notDetermined:
            // TODO: Prompt if access is not determined
            false
        case .restricted:
            true
        case .denied:
            false
        case .authorized:
            true
        case .limited:
            true
        @unknown default:
            false
        }
    }
    
    func groupMedia() -> [MediaSection] {
        var media = [MediaItem]()
        
        assets.enumerateObjects { asset, _, _ in
            let item = MediaItem(from: asset)
            guard let item, item.isMemory else { return }
            media.append(item)
        }
        
        let mediaGroupedByYear = media.reduce(into: [:] as [Int: [MediaItem]]) { acc, media in
            let components = Calendar.current.dateComponents([.year], from: media.createdDate)
            guard let year = components.year else { return }
            acc[year, default: []].append(media)
        }
        
        return mediaGroupedByYear
            .map { key, values in
                MediaSection(
                    year: key,
                    media: values.sorted(by: { $0.createdDate > $1.createdDate })
                )
            }
            .sorted(by: { $0.year > $1.year })
    }
    
    func getImage(
        _ asset: PHAsset,
        targetSize: CGSize?,
        contentMode: PHImageContentMode = .default
    ) async -> UIImage? {
        do {
            return try await photosService.getImage(
                asset: asset,
                targetSize: targetSize ?? PHImageManagerMaximumSize,
                contentMode: contentMode
            )
        } catch {
            logger.log(error)
            return nil
        }
    }
    
    func getVideo(asset: PHAsset) async -> AVPlayerItem? {
        do {
            return try await photosService.getVideo(asset: asset)
        } catch {
            logger.log(error)
            return nil
        }
    }
    
    func sendNotification() async {
        // 8am
        let date = DateComponents(hour: 8, minute: 0)

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(
            identifier: "Shaba",
            content: .init(),
            trigger: trigger
        )
        do {
            try await UNUserNotificationCenter.current().add(request)
            logger.info("Notification scheduled")
        } catch {
            logger.log(error)
        }
    }
}
