//
//  SirpaApp.swift
//  Sirpa
//
//  Created by iosdev on 9.11.2022.
//

import SwiftUI

@main
struct SirpaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
