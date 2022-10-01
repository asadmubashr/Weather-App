//
//  Weather_AppApp.swift
//  Weather App
//
//  Created by Apple on 10/2/22.
//

import SwiftUI

@main
struct Weather_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
