import SwiftUI
import CoreData
import Firebase
import FirebaseStorage

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
    @State var tripName = ""
    @State var notes = ""
    @State var id = ""
    @State var timeAdded = ""
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    @State var tripID = ""
    @State var imageDictionary = [String:UIImage]()
    @State var imageList = [UIImage]()
    @State var filteredImageDictionary = [String:UIImage]()
    
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
                
                //Upload button
                if selectedImage != nil {
                    Button {
                        // Upload image
                        uploadPhoto()
                    } label: {
                        Text("Upload photo")
                    }
                }
            }
            .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                // image picker
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            }
            .onAppear {
                retreiveAllPhotos()
            }
            
            
            List(model.tripList) {
                item in
                    NavigationLink {
                        Text("Item at \(item.tripName) with id \(item.id)")
                        
               
                        Button("kissa") {
                            
                            var kissa = imageDictionary.filter{
                                $0.key.contains("1QZMUpIbh1RjAYXoFQwS")
                            }.map {
                                $0.value
                            }
                            print("kissa \(kissa) \(imageDictionary)")
                        }
////
//                        List($imageDictionary.values, id: \.self) { image in
//                            Image(uiImage: image as! UIImage)
//                                .resizable()
//                                .frame(width: 200, height: 200)
//                        }
                        
                        
                        List(model.postList.filter {
                            $0.tripID.contains(item.id)
                        }) {
                            item in
                                Text(item.notes)
                            List(imageDictionary.filter{
                                $0.key.contains(item.id)
                            }.map {
                                $0.value
                            }
                                 , id: \.self) { item in
                                Image(uiImage: item)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                            }
                                 .frame(width: 200, height: 300)
//                            List(retrievedImages, id: \.self) { image in
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .frame(width: 200, height: 200)
//                            }
                        }
                
                        Divider()
                        
                        
                    } label: {
                        Text(item.tripName)
                    }
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
            Divider()
        
            HStack {
            
                List(retrievedImages, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 200, height: 200)
                }
            }
            
            TextField("post notes", text: $notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button {
                uploadPhoto()
                // clear the text fields
                selectedImage = nil
            } label: {
            Text("Add item")
        }
    }
        

}
            
    
    func uploadPhoto () {
        //make sure selected image property isnt nil
        guard selectedImage != nil else {
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        // turn image into data
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        // Check that we were able to convert it to data
        guard imageData != nil else {
            return
        }
        
        // specify file path and name
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        // upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) {
            metadata, error in
            // check for errors
            if error == nil && metadata != nil {

                // Save the data in the database in post collection
                model.addPostData(file: path, location: "test", notes: notes, timeAdded: timeStamp(), tripID: "test")
                if selectedImage != nil {
                    DispatchQueue.main.async {
                        self.retrievedImages.append(self.selectedImage!)
                    }
                }
                   
            }
        }
    }
    
    func retreiveAllPhotos() {
        // get the data from the database
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                
                var paths = Dictionary<String, String>()
                // loop through all the returned docs
                for doc in snapshot!.documents {
                    // extract the file path
                    paths.updateValue(doc[ "file"] as! String, forKey: doc.documentID)
                }
                
                // loop through each file path and fetch the data from storage
                for path in paths {
                    // get a reference to storage
                    let storageRef = Storage.storage().reference()
                    // specify the path
                    let fileRef = storageRef.child(path.value)
                    
                    // retreive the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        // check for errors
                        if error == nil && data != nil {
                            // create a UIImage and put it in our array for display
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                    imageDictionary.updateValue(image, forKey: path.key)
                                    
                                }
                            }
                        }
                    }
                } // end loop throughs
            }
        }
    }
    
    func filteredImagesById(postIDforImage: String) -> Array<UIImage> {
        filteredImageDictionary = imageDictionary.filter{
            $0.key == postIDforImage
        }
        print("image dictionary funkkarissa \(imageDictionary)")
        print("filtered dictionary \(filteredImageDictionary)")
        for item in filteredImageDictionary {
            imageList.append(item.value)
        }
        print("imagelist \(imageList)")
        return imageList
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
