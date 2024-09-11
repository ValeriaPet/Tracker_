import Foundation

@objc(WeekdayValueTransformer)
final class WeekdayValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let weekdays = value as? [Weekday] else { return nil }
        return try? JSONEncoder().encode(weekdays) as NSData
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([Weekday].self, from: data as Data)
    }
    
    static func register() {
        let name = NSValueTransformerName(rawValue: String(describing: WeekdayValueTransformer.self))
        ValueTransformer.setValueTransformer(WeekdayValueTransformer(), forName: name)
    }
}
