//
//  ActionsListModel.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 14.02.2022.
//

import Foundation
import CoreData

protocol ActionsListCRUD {
    func createNewItem() -> SetItem
    func deleteItem(offsets: IndexSet)
}

class ActionsListModel: ObservableObject {
    var moc: NSManagedObjectContext
    let parent: Activity
    
    @Published var items = [SectionItem]()
    
    init(context: NSManagedObjectContext, parentActivity: Activity) {
        self.moc = context
        self.parent = parentActivity
        
//        update()
    }
    
    func update() {
//        let frequest = NSFetchRequest<SetItem>(entity: SetItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SetItem.timestamp, ascending: true)], predicate: NSPredicate(format: "origin.title == %@", parent.wrappedTitle))
        
        let fetchRequest: NSFetchRequest<SetItem>
        fetchRequest = SetItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "origin.title == %@", parent.wrappedTitle)
        
        do {
            let objects = try moc.fetch(fetchRequest)
            items = sectionsArray(from: objects)
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
                    result[index] = section
                }
            }
            else {
                result.append(SectionItem(id: date, items: [item]))
            }
        }

        return result
    }

    private let sectionFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
}

extension ActionsListModel: ActionsListCRUD {
    func createNewItem() -> SetItem {
        let newItem = SetItem(context: moc)
        newItem.timestamp = Date()
        newItem.origin = parent

        do {
            try moc.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        update()
        
        return newItem

    }
    
    func deleteItem(offsets: IndexSet) {
        
    }

    
}

extension ActionsListModel {
    struct SectionItem: Identifiable, Hashable {
        let id: String
        var items = [SetItem]()
    }
}
