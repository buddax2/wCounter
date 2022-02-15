//
//  MainView.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 12.02.2022.
//

import SwiftUI

import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.title, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Activity>

    @State private var showAddTaskView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        ExerciseView(activity: item).environment(\.managedObjectContext, viewContext)
                    } label: {
                        Text(item.wrappedTitle)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem {
                    Button {
                        showAddTaskView.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus.circle")
                    }
                }
            }
            Text("Select an item")
        }
        .background(Color.white)
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
        .sheet(isPresented: $showAddTaskView) {
            AddNewExerciseView()
                .environment(\.managedObjectContext, viewContext)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Activity(context: viewContext)
            newItem.title = "new activity"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
