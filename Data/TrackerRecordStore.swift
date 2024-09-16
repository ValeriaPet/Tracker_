
import CoreData
import UIKit

final class TrackerRecordStore {
    
    private weak var delegate: StoreService?
    private let context: NSManagedObjectContext
    
    init(delegate: StoreService) {
        self.delegate = delegate
        self.context = delegate.context
    }

    func fetchRecords() -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        guard let trackersCoreData = try? context.fetch(request) as [TrackerRecordCoreData] else {
            return []
        }
        
        let records = trackersCoreData.map {item in
            let record = item as AnyObject
            return TrackerRecord(trackerID: record.uuid ?? UUID(),
                                 date: record.date
            )
        }
        return records
    }
    
    func fetchRecordBy(id: UUID, date: Date) -> TrackerRecordCoreData? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                        #keyPath(TrackerRecordCoreData.uuid), id as CVarArg,
                                        #keyPath(TrackerRecordCoreData.date), date as CVarArg)
        guard let result = try? context.fetch(request) as [TrackerRecordCoreData],
              let record = result.first else{
            return nil
        }
        return record
    }
    
    func storeRecord(record: TrackerRecord) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.uuid = record.trackerID
        trackerRecordCoreData.date = record.date
        delegate?.saveContext()
    }
    
    func deleteRecord(record: TrackerRecord) {
        if let trackerRecordCoreData = fetchRecordBy(id: record.trackerID, date: record.date) {
            context.delete(trackerRecordCoreData)
            delegate?.saveContext()
        }
    }
}
