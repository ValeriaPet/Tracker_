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

enum Weekday: Int, CaseIterable, Codable {
    case sunday
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension Array where Element == Weekday {
    // Преобразование массива Weekday в строку
    var asString: String {
        return self.map { String($0.rawValue) }.joined(separator: ",")
    }
}

extension String {
    // Преобразование строки в массив Weekday
    var selectedDays: [Weekday] {
        return self.split(separator: ",").compactMap { Weekday(rawValue: Int($0) ?? 0) }
    }
}

extension UIColor {
    // Преобразование UIColor в Int16
    func toInt16() -> Int16 {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let rgb = (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
        return Int16(rgb)
    }

    // Преобразование Int16 обратно в UIColor
    convenience init(fromInt16 rgb: Int16) {
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


