import Foundation

struct TrackerData {
    static func getTrackerCategories() -> [TrackerCategory] {
        let today = Date()
        
        let categories: [TrackerCategory] = [
            TrackerCategory(name: "Happy House", trackers: [
                Tracker(id: UUID(),
                        title: "Поливать кактус",
                        color: .color3,
                        emoji: "🌱",
                        schedule: [.monday, .wednesday, .friday],
                        creationDate: today),
                
                Tracker(id: UUID(),
                        title: "Проклинать Куроо Тецуро",
                        color: .color11,
                        emoji: "😈",
                        schedule: [.monday, .tuesday, .wednesday],
                        creationDate: today)
            ]),
            TrackerCategory(name: "Favorite things", trackers: [
                Tracker(id: UUID(),
                        title: "Погладить кошку 500 раз",
                        color: .color1,
                        emoji: "🐱",
                        schedule: [.tuesday, .thursday],
                        creationDate: today),
                
                Tracker(id: UUID(),
                        title: "Попить кофе",
                        color: .color15,
                        emoji: "☕️",
                        schedule: [.saturday, .sunday],
                        creationDate: today)
            ])
        ]
        
        return categories
    }
}
