//
//  SirpaApp.swift
//  Sirpa
//
//  Created by iosdev on 9.11.2022.
//

import SwiftUI

@main
struct SirpaApp: App {
    let persistentController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(coreDM: CoreDataManager())
        }
    }
}
