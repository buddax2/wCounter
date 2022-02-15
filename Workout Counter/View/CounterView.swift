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
    }
    
    private func add() {
        item.counter += 1

        AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)

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

struct CounterView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let newItem = SetItem(context: viewContext)
        newItem.timestamp = Date()
        
        return CounterView(item: newItem).environment(\.managedObjectContext, viewContext)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

