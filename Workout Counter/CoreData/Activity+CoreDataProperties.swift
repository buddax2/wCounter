//
//  Activity+CoreDataProperties.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 12.02.2022.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var title: String?
    @NSManaged public var set: NSSet?

    public var wrappedTitle: String {
        title ?? "Unknown Activity"
    }
    
    public var setArray: [SetItem] {
        let set = set as? Set<SetItem> ?? []
        
        return set.sorted {
            $0.wrappedTimestamp < $1.wrappedTimestamp
        }
    }
}

// MARK: Generated accessors for set
extension Activity {

    @objc(addSetObject:)
    @NSManaged public func addToSet(_ value: SetItem)

    @objc(removeSetObject:)
    @NSManaged public func removeFromSet(_ value: SetItem)

    @objc(addSet:)
    @NSManaged public func addToSet(_ values: NSSet)

    @objc(removeSet:)
    @NSManaged public func removeFromSet(_ values: NSSet)

}

extension Activity : Identifiable {

}
