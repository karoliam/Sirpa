//
//  LaunchPage.swift
//  Sirpa
//
//  Created by Karoliina Multas on 30.11.2022.
//
import SwiftUI
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct Login: View {

    @ObservedObject var model = ViewModel()
    @Environment (\.managedObjectContext) var viewContext

    
    @State var username = ""
    @State var homeCountry = ""
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    @State var imageDictionary = [String:UIImage]()
    @State var isPickerShowing = false
    
    @State var localUserID = ""

    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.userID)]) var cdUserID:
    FetchedResults<OnlineUser>
    // core data
//    let coreDM: CoreDataManager
    //Saa textfieldistä arvon
    @State  var onlineUserID: String = ""
    
    @State  var onlineUsers: [OnlineUser] = [OnlineUser]()
    
//     func populateUsers() {
//        onlineUsers = coreDM.getAllOnlineUsers()
//    }

//    func getUserID () -> String{
//            for item in cdUserID {
//                fetchedID = item.userID!
//            }
//        return fetchedID
//        }

    var body: some View {
        ZStack {
            VStack {
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        .offset(y: -62)

                } else {
                    Circle()
                        .fill(.white)
                        .frame(width: 200, height: 200)
                        .offset(y: -62)
                        .onTapGesture {
                            isPickerShowing = true
                        }
                }
                Button("Choose profile photo") {
                    isPickerShowing = true
                }
                .foregroundColor(.white)
                .offset(y: -62)
                VStack {
//                    Button("print") {
//                        print("lol")
//                    }
                    TextField("Username", text: $username)
                        .frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.black)
                            .padding([.horizontal], 4)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                            .padding([.horizontal], 24)

                    
                    TextField("Home country", text: $homeCountry)
                        .frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.black)
                            .padding([.horizontal], 4)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                            .padding([.horizontal], 24)
                    Button("location"){
                        getUserID()
                    }
                    Text(localUserID)
                        //Upload button
                    if username != "" {
                        
                        
                        
                        NavigationLink (destination: ContentView().environment(\.managedObjectContext, self.viewContext)) {
                                Text("\(localUserID)")
                                    .font(
                                        .custom(
                                            "AmericanTypewriter",
                                            fixedSize: 24)
                                        .weight(.bold))
                                    .foregroundColor(.white)
                                    .padding(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.white))
                            }.padding(20)
                                .simultaneousGesture(TapGesture().onEnded{
                                    
                                    uploadPhoto()
                                    
                                })

                        }
                }
                .foregroundColor(.white)
                .offset(y: -24)
                    .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                        // image picker
                        ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                    }
                }
        }.background(
            Image("traveling")
        )
        .navigationBarBackButtonHidden(true)

      

 
            

        }

        
    func getUserID() {
        for item in cdUserID {
            print(item)
            localUserID = item.userID!
        }
        print("moi \(cdUserID)")
        print("moi \(localUserID)")
    }
    
    func uploadPhoto () {
        //make sure selected image property isnt nil
        guard selectedImage != nil else {
            return
        }

        // Create storage reference
        let storageRef = Storage.storage().reference()
        // turn image into data
        let imageData = selectedImage!.jpegData(compressionQuality: 0.1)
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
                model.addUserData(file: path, homeCountry: homeCountry, username: username, timeAdded: Timestamp())
                if selectedImage != nil {
                    DispatchQueue.main.async {
                        model.retrievedImages.append(self.selectedImage!)
                        // TODO: lisää tänne imageDictionary
                    }
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
                        CoreDataManager().saveUserID(userID: model.userList.map{$0.id}[0], context: viewContext)

                    }

                }

            }

        }

    }
    init() {
        model.getUserInfo()
    }
    
}



struct Login_Previews: PreviewProvider {

    static var previews: some View {
        Login().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
