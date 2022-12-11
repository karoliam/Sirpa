//
//  ProfileView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreData

struct ProfileView: View {
    
    
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
    @State private var presentAlert = false
    @State var mapMarkers = [MapMarkers]()
    @State var mapMarkerNew = MapMarkers(id: "", latitude: 0.0, longitude: 0.0, file: "", notes: "", timeStamp: Timestamp(), tripID: "", userID: "")
    @State var userID = ""
    @State var localUserID = ""

    @Environment(\.managedObjectContext) private var viewContext
    
    
//    @ObservedObject var model = ViewModel()
//    @State var tripName = ""
//    @State var notes = ""
//    @State var id = ""
//    @State var timeAdded = ""
//    @State var selectedImage: UIImage?
//    @State var retrievedImages = [UIImage]()
//    @State var tripID = ""
//    @State var imageDictionary = [String:UIImage]()
//    @State var imageList = [UIImage]()
//    @State var filteredImageDictionary = [String:UIImage]()
//    @State var filteredImageList = [UIImage]()

    @FetchRequest(sortDescriptors: [SortDescriptor(\.userID, order: .reverse)]) var cdUserID:
    FetchedResults<OnlineUser>
        
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    HStack{
          
                        Image(systemName:"person.fill.turn.down")
                            .font(.system(size: 100))
                        
                        
                        VStack{
                            Text("10")
                            Text("trips")
                        }
                        VStack{
                            Text("10")
                            Text("followers")
                        }
                        .padding()
                        VStack{
                            Text("10")
                            Text("following")
                        }
                    }
                    Button(action: {print("moi")}){
                        Text("follow")
                            .frame(width: 100, height: 40)
                            .background(Color.red)
                        
                    }
                    List(model.tripList.filter {
                        $0.userID.contains(getUserID())
                    }) {
                                item in
                                NavigationLink {
                                    Text("Item at \(item.tripName) with id \(item.id)")
                                        // posts
                                        List(model.postList.filter {
                                            $0.tripID.contains(item.id)
                                        }) {
                                            item in
                                            Text(item.notes)
//                                            List(imageDictionary.filter{
//                                                $0.key.contains(item.id)
//                                            }.map {
//                                                $0.value
//                                            }
//                                                 , id: \.self) { item in
//
//                                                Image(uiImage: item)
//                                                    .resizable()
//                                                    .frame(width: 200, height: 200)
//
//                                            }
//                                                 .frame(width: 200, height: 300)

                                        }
                                    
                                } label: {
                                    Text("\(item.tripName)")
                                        .foregroundColor(.black)
                                }
                            
                        
                    }
                        
  
                    
                    
//                    ScrollView{
//                        VStack{
//                            ForEach(0..<5){_ in
//                                HStack(spacing: 4){
//                                    ForEach(0..<2){_ in
//                                        NavigationLink(destination: DetailImageView(data: "TripID")){
//                                            ForEach(retrievedImages, id: \.self) { item in
//                                                Image(uiImage: item)
//                                                    .resizable()
//                                                    .frame(width: 200, height: 200)
//                                            }
//
//                                        }
//
//                                    }
//
//                                }
//                            }
//                        }
//                        Spacer()
//                    }
                }
            }.background(Color(white: 0.1))
                .foregroundColor(.white)
                .onAppear {
                    retreiveAllPostPhotos()
                }
                .navigationBarBackButtonHidden(true)
            
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
                model.addPostData(file: path, latitude: 0.0, longitude: 0.0, notes: notes, tripID: "test", timeAdded: Timestamp())
                if selectedImage != nil {
                    DispatchQueue.main.async {
                        self.retrievedImages.append(self.selectedImage!)
                    }
                }
                
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
        init() {
            model.getTripNames()
            model.getPosts()
        }
        func getUserID() -> String {
            DispatchQueue.main.async {
                for item in cdUserID {
                    localUserID = item.userID!
                }
            }
            return localUserID
        }
    }
    
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
        }
    }

