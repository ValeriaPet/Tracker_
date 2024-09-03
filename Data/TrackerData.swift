import Foundation

struct TrackerData {
    static func getTrackerCategories() -> [TrackerCategory] {
        let russianCalendar: Calendar = {
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: "ru_RU")
            calendar.firstWeekday = 2 
            guard let timeZone = TimeZone(identifier: "Europe/Moscow") else {
                  fatalError("TimeZone with identifier 'Europe/Moscow' not found")
              }
              calendar.timeZone = timeZone
            
            return calendar
        }()

        let today = Date()
        
        let categories: [TrackerCategory] = [
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
                        creationDate: russianCalendar.date(byAdding: .day, value: -1, to: today)!),
                
                Tracker(id: UUID(),
                        title: "Попить кофе",
                        color: .colorSelection15,
                        emoji: "☕️",
                        schedule: [.saturday, .sunday],
                        creationDate: russianCalendar.date(byAdding: .day, value: -5, to: today)!)
            ])
        ]
 
        return categories
    }
}
