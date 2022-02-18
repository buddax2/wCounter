//
//  ActionsListModel.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 14.02.2022.
//

import Foundation
import CoreData
import SwiftUI

protocol ActionsListCRUD {
    func createNewItem() -> SetItem
    func deleteItem(offsets: IndexSet)
}

class WorkoutListModel: ObservableObject {
    var moc: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    var parent: Activity
    var currentSetItem: SetItem?
    
    @Published var sections = [SectionItem]()
    
//    private var fetchRequest: NSFetchRequest<SetItem>
    
    init(parent: Activity) {
        self.parent = parent

//        fetchRequest = SetItem.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "origin.title == %@", parent.wrappedTitle)
//
        update()
    }
    
    func update() {
//        let frequest = NSFetchRequest<SetItem>(entity: SetItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SetItem.timestamp, ascending: true)], predicate: NSPredicate(format: "origin.title == %@", parent.wrappedTitle))
        
//        let fetchRequest: NSFetchRequest<SetItem>
//        fetchRequest = SetItem.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "origin.title == %@", parent.wrappedTitle)
        
        let fetchRequest = SetItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "origin.title == %@", parent.wrappedTitle)

        do {
            let objects = try moc.fetch(fetchRequest)
            sections = sectionsArray(from: objects)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func save() {
        currentSetItem?.origin = parent

        do {
            try moc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func sectionsArray(from items: [SetItem]) -> [SectionItem] {
        var result = [SectionItem]()
        
        items.forEach { item in
            let date = sectionFormatter.string(from: item.wrappedTimestamp)
            
            if result.filter({ $0.id == date }).isEmpty == false {
                if var section = result.filter({ $0.id == date }).first, let index = result.firstIndex(of: section) {
                    section.items.append(item)
                    section.items.sort(by: { $0.wrappedTimestamp > $1.wrappedTimestamp })
                    result[index] = section
                }
            }
            else {
                result.append(SectionItem(id: date, items: [item]))
            }
        }

        return result.sorted(by:{ $0.id > $1.id })
    }

    private let sectionFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
}

extension WorkoutListModel: ActionsListCRUD {
    func createNewItem() -> SetItem {
        let newItem = SetItem(context: moc)
        newItem.timestamp = Date()
        currentSetItem = newItem
//        newItem.origin = parent

//        do {
//            try moc.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
        
//        update()
        
        return newItem

    }
    
    func deleteItem(offsets: IndexSet) {
        let fetchRequest = SetItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "origin.title == %@", parent.wrappedTitle)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \SetItem.timestamp, ascending: false)]

        guard let objects = try? moc.fetch(fetchRequest) else { return }
        
        offsets.map { objects[$0] }.forEach(moc.delete)

        do {
            try moc.save()
            update()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }

    
}

struct SectionItem: Identifiable, Hashable {
    let id: String
    var items = [SetItem]()
}
