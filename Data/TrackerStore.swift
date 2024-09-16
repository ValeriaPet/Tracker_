
import CoreData
import UIKit

final class TrackerStore {
    
    private weak var delegate: StoreService?
    private let context: NSManagedObjectContext
    
    init(delegate: StoreService) {
        self.delegate = delegate
        self.context = delegate.context
    }
    
    func addToStore(tracker: Tracker, eventDate: Date?) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)

        trackerCoreData.id = tracker.id
        trackerCoreData.creationDate = tracker.creationDate
        trackerCoreData.title = tracker.title
        trackerCoreData.color = UIColor(fromInt16: trackerCoreData.color as! Int16) // Преобразование цвета
        trackerCoreData.emoji = tracker.emoji  // Сохранение emoji как строки
        trackerCoreData.schedule = tracker.schedule.asString  // Преобразование массива Weekday в строку

        return trackerCoreData
    }
    
    func allTrackersCount() -> Int {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.resultType = .countResultType
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count
    }
}
