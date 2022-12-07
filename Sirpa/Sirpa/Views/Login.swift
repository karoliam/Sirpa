//
//  LaunchPage.swift
//  Sirpa
//
//  Created by Karoliina Multas on 30.11.2022.
//

import SwiftUI
import FirebaseStorage
import CoreData

struct Login: View {
    
    @ObservedObject var model = ViewModel()
    @Environment (\.managedObjectContext) var managedObjectContext

    
    @State var username = ""
    @State var homeCountry = ""
    @State var userID: User?
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    @State var imageDictionary = [String:UIImage]()
    @State var isPickerShowing = false

    // core data
//    let coreDM: CoreDataManager
    //Saa textfieldistä arvon
    @State  var onlineUserID: String = ""
    
    @State  var onlineUsers: [OnlineUser] = [OnlineUser]()
    
//     func populateUsers() {
//        onlineUsers = coreDM.getAllOnlineUsers()
//    }
    
    
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
                    Button("print") {
                        print("print id \(CoreDataManager().getAllOnlineUsers())")
                    }
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

                        //Upload button
                    if selectedImage != nil && username != "" {
                            NavigationLink (destination: BottomTab()) {
                                Text("Login")
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
                model.addUserData(file: path, homeCountry: homeCountry, username: username)
                if selectedImage != nil {
                    DispatchQueue.main.async {
                        self.retrievedImages.append(self.selectedImage!)
                        CoreDataManager().saveUserID(userID: model.userList.map{$0.id}.last as! String)
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
        Login()
    }
}
