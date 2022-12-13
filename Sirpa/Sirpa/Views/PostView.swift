//
//  PostView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CoreData

struct PostView: View {
    @State private var username: String = ""
    @State var choiceMade = "Trips"
    @State var chosenTripID = ""
    @ObservedObject var model = ViewModel()
    @State var tripName = ""
    @State var notes = ""
    //    @State var tripNameList: Array<String>
    @State var tripID = ""
    @State private var selection = ""
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?

    @State var imageList = [UIImage]()
    @State var filteredImageDictionary = [String:UIImage]()
    @State private var presentAlert = false
    @State private var showNewTrip = false
    @State var localUserID = ""

//    @State private var is
    // Voice Recognition
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var buttonText = "press to record"
    @State private var voiceMicImage = "mic"
    @State private var voiceMicColor:Color = .blue
    @State var imageDictionary = [String:UIImage]()

    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.userID)]) var cdUserID:
    FetchedResults<OnlineUser>
    
    var body: some View {
        ZStack {
            Color(white: 0.07).edgesIgnoringSafeArea(.all)
            VStack{
                    Text("Create a new memory")
                        .foregroundColor(.white)
                        .font(
                            .custom(
                                "AmericanTypewriter",
                                fixedSize: 24)
                            .weight(.bold))
                        .foregroundColor(.white)
                        .padding(16)
                HStack(alignment: .top){
                    VStack {
                        Menu{
                            
                            Button("+ Add new trip") {
                                showNewTrip = true
                            }
                            
                            
                            ForEach(model.tripList.filter{$0.id.contains(getUserID())}.map{item in item.tripName + "#" + item.id}, id: \.self) { item in
                                Button(action: {
                                    choiceMade = String(item.split(separator: "#")[0])
                                    chosenTripID = String(item.split(separator: "#")[1])
                                }, label: {
                                    Text("\(String(item.split(separator: "#")[0]))")
                                })
                                .offset(x: -100)
                            }
                        } label: {
                            Label(
                                title: {Text("\(choiceMade)")}, icon: {Image.init(systemName: "plus")}
                            )
                        }
                        .frame(width: 200, height: 40)
                        .background(.white)
                        .cornerRadius(4)
                        .padding()
                        if (showNewTrip == true){
                            TextField("Trip name", text: $tripName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Add") {
                                    model.addTripData(userID: getUserID(), tripName: tripName, timeAdded: Timestamp())
                                choiceMade = tripName
                                tripName = ""
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    chosenTripID = String(model.tripList.map{$0.id}[0])
                                }
                                showNewTrip = false
                            }
                        }
                    }
                    
                    VStack {
                        if selectedImage == nil {
                                Image("small-palm")
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(8)
                                    .overlay(Image(systemName: "camera.fill")
                                        .foregroundColor(.white))
                                    .simultaneousGesture(TapGesture().onEnded{
                                                         isPickerShowing = true
                                                     })
                        }
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .frame(width: 120, height: 120)
                        }
                        Button {
                            isPickerShowing = true
                        } label: {
                            Text("Select photo")
                        }
                    }
                    .padding()

   
                }
                VStack {
                    ZStack(alignment: .leading) {
                        TextEditor(text: $notes)
                            .frame(height: 200)
                            .padding()
                        if(notes.isEmpty) {
                            Text("Write or click the microphone to dictate your notes")
                                .padding(24)
                                .offset(y: -70)
                                .foregroundColor(Color(white: 0.8))
                            
                        }
                        Button(action: {
                            isRecording = !isRecording
                            print($isRecording)
                            if (isRecording == true) {
                                buttonText = "press to stop recording"
                                speechRecognizer.reset()
                                speechRecognizer.transcribe()
                                self.voiceMicColor = .red
                                self.voiceMicImage = "mic.slash"
                            } else {
                                buttonText = "press to record"
                                speechRecognizer.stopTranscribing()
                                notes = notes + " " + speechRecognizer.transcript
                                self.voiceMicColor = .blue
                                self.voiceMicImage = "mic"
                            }
                        })
                        {
                            Image(systemName: voiceMicImage)
                                .foregroundColor(voiceMicColor)
                                .font(.system(size:32))
                        }
                        .padding(24)
                        .offset(y: 70)

                    }
           
                    HStack{
                        //Upload button
                        if selectedImage != nil {
                            NavigationLink("Post!", destination: ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext))
                                .simultaneousGesture(TapGesture().onEnded{
                                                     uploadPhoto()
                                                 })
                        }
                    }
                    .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                        // image picker
                        ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                    }
                }
                    
            }

        }


            
        }

    init() {
    model.getTripNames()
    model.getPosts()
    model.retreiveAllPostPhotos()
    }
    
    
    func getUserID() -> String {
        for item in cdUserID {
            localUserID = item.userID!
        }
        return localUserID
    }
//    //timestamp
//    func timeStamp() -> String {
//        let now = Date()
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone.current
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let dateString = formatter.string(from: now)
//        return dateString
//    }
    
    func uploadPhoto() {
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
               
                    model.addPostData(file: path,  latitude: 0.0, longitude: 0.0, notes: notes, tripID: chosenTripID, timeAdded: Timestamp())
                    print("adding data succesfully")
              
                if selectedImage != nil {
                    DispatchQueue.main.async {
                        model.retrievedImages.append(self.selectedImage!)
                        imageDictionary.updateValue(self.selectedImage!, forKey: model.postList.map{$0.id}[0])
                    }
                }
                
            }
        }
    }

    
    
    }



struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


