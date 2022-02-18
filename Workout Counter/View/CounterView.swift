//
//  CounterView.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 01.02.2022.
//

import SwiftUI
import AudioToolbox

struct CounterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var item: SetItem
    @StateObject var model: WorkoutListModel
//    var model: ActionsListModel
//
//    init(item: SetItem, dataModel: ActionsListModel) {
//        self.model = dataModel
//    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("\(item.counter)")
                .font(.system(size: 145))
                .padding(.top, 50)
            
            Spacer()
            
            Button(action: add) {
                Circle()
                    .foregroundColor(Color.red)
                    .frame(width: 300, alignment: .center)
            }
            
            Spacer()
        }
        .onDisappear {
            item.endTime = Date()
            
            let duration = item.wrappedEndTime.timeIntervalSince(item.wrappedTimestamp)
            print("Duration: \(duration)")
            
            model.save()
            model.update()
        }
        .onAppear {
            let duration = item.wrappedEndTime.timeIntervalSince(item.wrappedTimestamp)
            print("Duration at start: \(duration)")
        }
    }
    
    private func add() {
        item.counter += 1

        AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)

        do {
            try viewContext.save()
            model.update()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        print(item.counter)
    }
}

struct CounterView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let activity = Activity(context: viewContext)

        let newItem = SetItem(context: viewContext)
        newItem.timestamp = Date()
        newItem.origin = activity
        
        
        let newModel = WorkoutListModel(parent: activity)
        return CounterView(item: newItem, model: newModel).environment(\.managedObjectContext, viewContext)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

