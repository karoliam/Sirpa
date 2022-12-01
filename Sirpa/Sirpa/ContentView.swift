//
//  ContentView.swift
//  Sirpa
//
//  Created by iosdev on 9.11.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //Coredata
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var post: FetchedResults<OnlinePost>
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
        //Coredata lista
        List(post) { post in
            Text(post.autoID ?? "Unknown")
            Text(post.postID ?? "Unknown")
        }
        
        Button("add") {
            let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
            let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
            
            let chosenFirstName = firstNames.randomElement()!
            let chosenLastName = lastNames.randomElement()!
            
            let post = OnlinePost(context: moc)
            post.autoID = "moi"
            post.postID = "\(chosenFirstName) \(chosenLastName)"
            
            try? moc.save()
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
