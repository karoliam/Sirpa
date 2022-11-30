//
//  LaunchPage.swift
//  Sirpa
//
//  Created by Karoliina Multas on 30.11.2022.
//

import SwiftUI
import FirebaseStorage

struct LaunchPage: View {
    
    @ObservedObject var model = ViewModel()

    @State var username = ""
    @State var homeCountry = ""
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    @State var imageDictionary = [String:UIImage]()
    @State var isPickerShowing = false

    
    var body: some View {
        VStack {
            Circle()
                .fill(.red)
                .onTapGesture {
                    print("clicked")
                }
                .frame(width: 200, height: 200)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Home country", text: $homeCountry)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        
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
                    NavigationLink ("Login", destination: ContentView())
                        .simultaneousGesture(TapGesture().onEnded{
                            uploadPhoto()
                        })

//                    Button {
//                        // Upload image
//                        // Navigate to main feed
//                    } label: {
//                        Text("Login!")
//                    }
                }
            }
            .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                // image picker
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
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
                model.addUserData(file: path, homeCountry: homeCountry, username: username)
                if selectedImage != nil {
                    DispatchQueue.main.async {
                        self.retrievedImages.append(self.selectedImage!)
                    }
                }
                   
            }
        }
    }
    
    
    
    init() {
        model.getUserInfo()
    }

}



struct LaunchPage_Previews: PreviewProvider {
    static var previews: some View {
        LaunchPage()
    }
}
