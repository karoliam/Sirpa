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
    @State var profilePhoto = [UIImage]()
    @State var imageDictionary = [String:UIImage]()
    @State var profileImageDictionary = [String:UIImage]()
    @State var imageList = [UIImage]()
    @State var filteredImageDictionary = [String:UIImage]()
    @State private var presentAlert = false
    @State var mapMarkers = [MapMarkers]()

    @State var userID = ""
    @State var localUserID = ""
    @State var notesShown = false

    @Environment(\.managedObjectContext) private var viewContext
    


    @FetchRequest(sortDescriptors: [SortDescriptor(\.userID, order: .reverse)]) var cdUserID:
    FetchedResults<OnlineUser>

    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    HStack{
                        VStack{
                            Text("\(model.userList.filter{$0.id == getUserID() }.map{$0.username}.first as? String ?? "no username found")")
                                .foregroundColor(.white)
                        }
                    

                        
                        VStack{
                            Text("\(String(model.tripList.filter {$0.userID.contains(getUserID())}.count))")
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
                                ZStack{
//                                    ScrollView{
                                                HStack(spacing: 4){
                                                    
                                                        if(notesShown == true) {
                                                            List(model.imageDictionary.filter{
                                                                $0.key.contains(item.id)
                                                            }.map {
                                                                $0.value
                                                            }
                                                                 , id: \.self) { item in
                                                                
                                                                Image(uiImage: item)
                                                                    .resizable()
                                                                    .frame(width: 390, height: 600)
                                                                    .opacity(0.5)
                                                                
                                                            }
                                                                 .frame(width: 390, height: 600)
                                                                 .foregroundColor(.white)
                                                                 .overlay(alignment: .center) {
                                                                    VStack{
                                                                        HStack{
                                                                            VStack{
                                                                                //PROFILEPIC JA DATE ADDED
                                                                                Text("\(Date(), style: .date)")
                                                                            }
                                                                            VStack{
                                                                                //IF SHARED
                                                                                Text("Shared")
                                                                            }
                                                                            .padding()
                                                                            VStack{
                                                                                //TIMEADDED
                                                                                Text("\(Date(), style: .time)")
                                                                            }
                                                                        }
                                                                        Spacer()
                                                                        HStack {
                                                                            Image(systemName:"person.fill")
                                                                                .font(.system(size: 50))
                                                                            Circle()
                                                                                .fill(Color.red)
                                                                                .frame(width: 150, height: 150)
                                                                                .padding(30)
                                                                        }
                                                                        Spacer()
                                                                        HStack {
                                                                            //NOTES
                                                                            Text("\(item.notes)")
                                                                        } .frame(width: 350)
                                                                        Spacer()
                                                                    }
                                                                }
                                                                .onTapGesture(count: 1) {
                                                                    notesShown.toggle()
                                                                }
                                                        } else {
                                                            List(model.imageDictionary.filter{
                                                                $0.key.contains(item.id)
                                                            }.map {
                                                                $0.value
                                                            }
                                                                 , id: \.self) { item in
                                                                
                                                                Image(uiImage: item)
                                                                    .resizable()
                                                                    .frame(width: 390, height: 600)
                                                                
                                                            }
                                                                 .frame(width: 390, height: 600)
                                                                    .onTapGesture(count: 1) {
                                                                        notesShown.toggle()
                                                                    }
                                                                
                                                            }
                                                        
                                                    
                                            

                                    }
                                }.navigationBarTitle("Trip place", displayMode: .inline)
                                    .navigationBarBackButtonHidden(true)
                                
                                
                                
                            }
                            
                        } label: {
                            Text("\(item.tripName)")
                                .foregroundColor(.black)
                        }
                        
                        
                    }
                
  
        
                }
            }.background(Color(white: 0.1))
                .foregroundColor(.white)
            
        }
    }
    
    private var notesOnPicture: some View {
        VStack{
            HStack{
                VStack{
                    //PROFILEPIC JA DATE ADDED
                    Text("\(Date(), style: .date)")
                }
                VStack{
                    //IF SHARED
                    Text("Shared")
                }
                .padding()
                VStack{
                    //TIMEADDED
                    Text("\(Date(), style: .time)")
                }
            }
            Spacer()
            HStack {
                Image(systemName:"person.fill")
                    .font(.system(size: 50))
                Circle()
                    .fill(Color.red)
                    .frame(width: 150, height: 150)
                    .padding(30)
            }
            Spacer()
            HStack {
                //NOTES
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
            } .frame(width: 350)
            Spacer()
        }
    }

    


        
//        func retreiveAllPostPhotos() {
//            // get the data from the database
//            let db = Firestore.firestore()
//            db.collection("posts").getDocuments { snapshot, error in
//                if error == nil && snapshot != nil {
//
//                    var paths = Dictionary<String, String>()
//                    // loop through all the returned docs
//                    for doc in snapshot!.documents {
//                        // extract the file path
//                        paths.updateValue(doc[ "file"] as! String, forKey: doc.documentID)
//
//                    }
//
//                    // loop through each file path and fetch the data from storage
//                    for path in paths {
//                        // get a reference to storage
//                        let storageRef = Storage.storage().reference()
//                        // specify the path
//                        let fileRef = storageRef.child(path.value)
//                        // retreive the data
//                        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                            // check for errors
//                            if error == nil && data != nil {
//                                // create a UIImage and put it in our array for display
//                                if let image = UIImage(data: data!) {
//                                    DispatchQueue.main.async {
//                                        retrievedImages.append(image)
//                                        imageDictionary.updateValue(image, forKey: path.key)
//
//                                    }
//                                }
//                            }
//                        }
//                    } // end loop throughs
//                }
//            }
//        }
        init() {
            model.getTripNames()
            model.getPosts()
            model.getUserInfo()
            model.retreiveAllPostPhotos()
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

