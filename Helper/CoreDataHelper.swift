import CoreData
import UIKit

class CoreDataHelper {

    // Ссылка на context, которая будет передаваться через AppDelegate
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Метод для сохранения нового трекера
    func saveTracker(name: String, color: UIColor) {
        let newTracker = TrackerCoreData(context: context)
        newTracker.title = name
        newTracker.color = color
        
        do {
            try context.save()
            print("Tracker saved successfully!")
        } catch {
            print("Failed to save tracker: \(error)")
        }
    }

    // Метод для извлечения трекеров
    func fetchAllTrackers() -> [TrackerCoreData] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        do {
            let trackers = try context.fetch(fetchRequest)
            return trackers
        } catch {
            print("Failed to fetch trackers: \(error)")
            return []
        }
    }
}
