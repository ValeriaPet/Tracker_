
import Foundation
import CoreData
import UIKit


final class TrackerStore {
    

    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    internal func addNewTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) throws {
        guard let trackerEntity = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: context) else {
            throw NSError(domain: "TrackerStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to find entity description"])
        }

        let newTracker = TrackerCoreData(entity: trackerEntity, insertInto: context)
        newTracker.id = tracker.id
        newTracker.title = tracker.title
        newTracker.color = UIColorTransform.hexString(from: tracker.color)
        newTracker.emoji = tracker.emoji
        newTracker.creationDate = tracker.creationDate  // Устанавливаем значение creationDate
        newTracker.schedule = tracker.schedule.map { $0.rawValue } as NSArray

        // Устанавливаем категорию
        newTracker.category = category

        do {
            try context.save()
        } catch {
            throw error
        }
    }

    internal func fetchTrackers() -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        do {
            let trackerCoreDataArray = try context.fetch(fetchRequest)
            let trackers = trackerCoreDataArray.compactMap { decodingTracker(from: $0) }
            return trackers
        } catch {
            print("Failed to fetch trackers: \(error)")
            return []
        }
    }
}

extension TrackerStore {
    private func decodingTracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.id,
              let title = trackerCoreData.title,
              let colorHex = trackerCoreData.color,
              let emoji = trackerCoreData.emoji else { return nil }

        let color = UIColorTransform.color(from: colorHex)

        // Десериализация массива строк обратно в массив Weekday
        let schedule: [Weekday]
        if let scheduleArray = trackerCoreData.schedule as? [String] {
            schedule = scheduleArray.compactMap { Weekday(rawValue: $0) }
        } else {
            schedule = []
        }

        return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule, creationDate: Date())
    }


    private func fetchTrackerCoreData(by id: UUID) -> TrackerCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let trackers = try context.fetch(fetchRequest)
            return trackers.first
        } catch {
            print("Failed to fetch tracker by ID: \(error)")
            return nil
        }
    }
}
