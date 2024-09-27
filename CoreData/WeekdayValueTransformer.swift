import Foundation

@objc(WeekdayValueTransformer)
final class WeekdayValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { NSData.self }

    override class func allowsReverseTransformation() -> Bool { true }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let weekdays = value as? [Weekday] else { return nil }
        let ints = weekdays.map { $0.rawValue }
        return try? NSKeyedArchiver.archivedData(withRootObject: ints, requiringSecureCoding: false)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data,
              let ints = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Int] else { return nil }
        return ints.compactMap { Weekday(rawValue: $0) }
    }
}

