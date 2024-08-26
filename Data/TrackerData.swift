import Foundation

struct TrackerData {
    static func getTrackerCategories() -> [TrackerCategory] {
        let calendar = Calendar.current
        let today = Date()
        
        var categories: [TrackerCategory] = [
            TrackerCategory(name: "Happy House", trackers: [
                Tracker(id: UUID(),
                        title: "Поливать кактус",
                        color: .colorSelection3,
                        emoji: "🌱",
                        schedule: [.monday, .wednesday, .friday],
                        creationDate: today),
                
                Tracker(id: UUID(),
                        title: "Проклинать Куроо Тецуро",
                        color: .colorSelection11,
                        emoji: "😈",
                        schedule: [.monday, .tuesday, .wednesday],
                        creationDate: today)
            ]),
            TrackerCategory(name: "Favorite things", trackers: [
                Tracker(id: UUID(),
                        title: "Погладить кошку 500 раз",
                        color: .colorSelection1,
                        emoji: "🐱",
                        schedule: [.tuesday, .thursday],
                        creationDate: calendar.date(byAdding: .day, value: -1, to: today)!),
                
                Tracker(id: UUID(),
                        title: "Попить кофе",
                        color: .colorSelection15,
                        emoji: "☕️",
                        schedule: [.saturday, .sunday],
                        creationDate: calendar.date(byAdding: .day, value: -5, to: today)!)
            ])
        ]
 
        return categories
    }
}
