import SwiftUI
import CoreData
import Firebase

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
    @State var tripName = ""
    @State var notes = ""
    @State var timeAdded = ""
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    //timestamp
    func timeStamp() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }

    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        VStack{
            VStack {
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 200, height: 200)

                }
                
                Button {
                    isPickerShowing = true
                } label: {
                    Text("Select photo")
                }
            }
            .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                // image picker
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            }

            List(model.tripList) {
                item in Text(item.tripName)
                }
            List(model.postList) {
                item in
            HStack {
                    Text(item.notes)
                    Spacer()
                    Button(action: {
                        model.deletePost(postToDelete: item)
                    }, label: {
                        Image(systemName: "minus.circle")
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
            }

            TextField("Trip name", text: $tripName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                model.addTripData(postID: "testipostID", userID: "testiUserID", tripName: tripName, timeAdded: timeStamp())
                // clear the text fields
                tripName = ""
        }, label: {
            Text("Add item")
        })
        
    }
                   }
                 
                   
    init() {
        model.getTripNames()
        model.getPosts()
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
