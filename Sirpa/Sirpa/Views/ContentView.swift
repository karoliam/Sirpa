import SwiftUI
import CoreData
import Firebase
import FirebaseStorage
import CoreLocation
import FirebaseFirestore

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
//        @FetchRequest(sortDescriptors: [SortDescriptor(\.userID, order: .reverse)]) var cdUserID:
//        FetchedResults<OnlineUser>
    
    
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
    @State private var presentAlert = false
    @State var mapMarkers = [MapMarkers]()
    @State var mapMarkerNew = MapMarkers(id: "", coordinate: CLLocationCoordinate2D(), file: "", notes: "", timeStamp: Timestamp(), tripID: "", userID: "")
    @State var userID = ""
    
    //timestamp
    func timeStamp() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }



    var body: some View {
        ZStack{
  
                
            BottomTab(markers: $mapMarkers)
            Button("load markers"){
                addingDataToMapMarkers()
            }
                
        
        }
        .navigationBarBackButtonHidden(true)

}
            
    
    func addingDataToMapMarkers() {
        
        for item in model.tripList {
            userID = item.userID
        }
        for item in model.postList {
            
            mapMarkerNew = MapMarkers(id: item.id, coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), file: item.file, notes: item.notes, timeStamp: Timestamp(), tripID: item.tripID, userID: userID)
            
            print(mapMarkerNew)
                mapMarkers.append(mapMarkerNew)
        }
        print("markkers being added")
        print( mapMarkers)
    }
    
    

    
    func retreiveAllPostPhotos() {
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
