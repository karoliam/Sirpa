//
//  SirpaApp.swift
//  Sirpa
//
//  Created by iosdev on 9.11.2022.
//

import SwiftUI

@main
struct SirpaApp: App {
    //vaihdoin K
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            //Vaihdoin K
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
