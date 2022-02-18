//
//  ContentView.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 01.02.2022.
//

import SwiftUI
import CoreData
import AudioToolbox

struct ExerciseView: View {
//    @Environment(\.managedObjectContext) private var viewContext

    @StateObject var model: WorkoutListModel
    
//    private var items: FetchRequest<SetItem>
    
    
//    let activity: Activity
    
    @State private var showAddTaskView = false
    @State private var selectedItem: Date? = nil

//    init(dataModel: ActionsListModel) {
//        self.model = dataModel
//        items = FetchRequest<SetItem>(entity: SetItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SetItem.timestamp, ascending: false)], predicate: NSPredicate(format: "origin.title == %@", model.parent.wrappedTitle))
//    }

//    struct SectionItem: Identifiable, Hashable {
//        let id: String
//        var items = [SetItem]()
//    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            VStack {
                List {
//                    ForEach(items.wrappedValue) { item in
//                        NavigationLink(tag: item.wrappedTimestamp, selection: $selectedItem, destination: {
//                            CounterView(item: item)
//                        }, label: {
//                            HStack {
//                                Text(item.timestamp!, formatter: sectionFormatter).font(.footnote).foregroundColor(.secondary)
//                                Text(item.timestamp!, formatter: itemFormatter).font(.body)
//
//                                Spacer()
//
//                                Text("\(item.counter)")
//                            }
//                        })
//                    }
//                    .onDelete(perform: deleteItems)
                    ForEach(model.sections, id: \.self) { sectionItem in
                        Section(sectionItem.id) {
                            ForEach(sectionItem.items) { item in
//                                NavigationLink {
//                                    CounterView(item: item, model: model)
//                                } label: {
                                    HStack {
                                        Text(item.wrappedTimestamp, formatter: itemFormatter)

                                        Spacer()

                                        Text("\(item.counter)")
                                    }
//                                }
                            }
                            .onDelete { indexSet in
                                model.deleteItem(offsets: indexSet)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    VStack {
                        Text("Сьогодні: \(model.sections.first?.items.filter({ Calendar.current.isDateInToday($0.wrappedTimestamp) == true }).reduce(0, { partialResult, item in partialResult + item.counter }) ?? 0)")
                            .font(.footnote)
                            .padding(.leading, 8)
                    }
                }
            }
            .navigationTitle(model.parent.wrappedTitle)

            NavigationLink {
                CounterView(item: model.createNewItem(), model: model)
            } label: {
                SmallAddButton()
                    .padding()
            }
//            SmallAddButton()
//                .padding()
//                .onTapGesture {
//                    let newItem = model.createNewItem()
////                    let newItem = addItem()
//
//                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
//                        selectedItem = newItem.wrappedTimestamp
//                    })
//
////                    showAddTaskView.toggle()
//                }
        }
//        onAppear {
//            model.update()
//        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(Color.white)
    }

//    private func addItem() -> SetItem {
//        AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
//
//        let newItem = SetItem(context: viewContext)
//        newItem.timestamp = Date()
//        newItem.origin = model.parent
//
//        withAnimation {
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//
//        return newItem
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
//
//        withAnimation {
//            offsets.map { items.wrappedValue[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func sectionsArray(_ items: FetchRequest<SetItem>) -> [SectionItem] {
//        var result = [SectionItem]()
//
//        items.wrappedValue.forEach { item in
//            let date = sectionFormatter.string(from: item.wrappedTimestamp)
//
//            if result.filter({ $0.id == date }).isEmpty == false {
//                var section = result.filter({ $0.id == date }).first
//                section?.items.append(item)
//            }
//            else {
//                result.append(SectionItem(id: date, items: [item]))
//            }
//        }
//
//        return result
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
}()

private let sectionFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yy"
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let activity = Activity(context: PersistenceController.preview.container.viewContext)
        activity.title = "Віджимання"
        
        let model = WorkoutListModel(parent: activity)
        
        return ExerciseView(model: model).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
