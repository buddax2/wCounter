//
//  Workout_CounterApp.swift
//  Workout Counter
//
//  Created by Oleksandr Yakubchyk on 01.02.2022.
//

import SwiftUI

@main
struct Workout_CounterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
