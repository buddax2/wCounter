//
//  AddNewExerciseView.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 12.02.2022.
//

import SwiftUI
import AudioToolbox

struct AddNewExerciseView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var title: String = ""
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("New exercise")
                .font(.title3).bold()
                .foregroundColor(Color.black)
            
            TextField("Exercise name", text: $title)
                .textFieldStyle(.roundedBorder)
            
            Button {
                if !title.isEmpty {
                    AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)

                    let newItem = Activity(context: viewContext)
                    newItem.title = title

                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }

                }
                dismiss()
            } label: {
                HStack {
                    Spacer()
                    
                    Text("Add")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color(hue: 0.328, saturation: 0.796, brightness: 0.408))
                        .cornerRadius(30)
                }
            }
            
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal)
        .background(Color.white)
    }
}

struct AddNewActivity_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext

        return AddNewExerciseView().environment(\.managedObjectContext, viewContext)
    }
}
