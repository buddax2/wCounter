//
//  SetItem+CoreDataProperties.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 12.02.2022.
//
//

import Foundation
import CoreData


extension SetItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SetItem> {
        return NSFetchRequest<SetItem>(entityName: "SetItem")
    }

    @NSManaged public var counter: Int64
    @NSManaged public var timestamp: Date?
    @NSManaged public var origin: Activity?

    public var wrappedTimestamp: Date {
        timestamp ?? Date()
    }
}

extension SetItem : Identifiable {

}
