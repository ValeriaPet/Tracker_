
import CoreData
import UIKit

final class TrackerRecordStore {
    
    private let context: NSManagedObjectContext
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is not of type AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addNewRecord(from trackerRecord: TrackerRecord, isCompleted: Bool) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerRecordCoreData", in: context) else { return }
        let newRecord = TrackerRecordCoreData(entity: entity, insertInto: context)
        newRecord.uuid = trackerRecord.trackerID
        newRecord.date = trackerRecord.date
        newRecord.isCompleted = isCompleted
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func fetchAllRecords() -> [TrackerRecord] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            let trackerRecords = try context.fetch(fetchRequest)
            return trackerRecords.map { TrackerRecord(trackerID: $0.uuid ?? UUID(), date: $0.date ?? Date()) }
        } catch {
            print("Failed to fetch tracker records: \(error)")
            return []
        }
    }
    
    func deleteRecord(for trackerRecord: TrackerRecord) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@ AND date == %@", trackerRecord.trackerID as CVarArg, trackerRecord.date as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            if let recordToDelete = results.first {
                context.delete(recordToDelete)
                try context.save()
                print("Record deleted: \(trackerRecord)")
            } else {
                print("Record not found: \(trackerRecord)")
            }
        } catch {
            print("Failed to delete record: \(error)")
        }
    }
}
