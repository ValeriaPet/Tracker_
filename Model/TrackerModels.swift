import Foundation
import UIKit

// MARK: - Протокол делегата

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func didCompleteTracker(_ cell: TrackerCollectionViewCell, tracker: Tracker, isCompleted: Bool)
    func isTrackerCompletedToday(_ tracker: Tracker) -> Bool
    func totalCompletions(for tracker: Tracker) -> Int
}

// MARK: - Модели данных

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let creationDate: Date
}


struct TrackerCategory {
    var name: String
    var trackers: [Tracker]
}

struct TrackerRecord: Hashable {
    let trackerID: UUID
    let date: Date

    func hash(into hasher: inout Hasher) {
        hasher.combine(trackerID)
        hasher.combine(date)
    }

    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        return lhs.trackerID == rhs.trackerID && lhs.date == rhs.date
    }
}

// MARK: - Перечисление дней недели

enum Weekday: String, CaseIterable, Codable {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Cб"
    case sunday = "Вс"
}




