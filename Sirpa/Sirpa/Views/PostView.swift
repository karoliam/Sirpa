//
//  PostView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI
import Firebase
import FirebaseStorage

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
    @State var retrievedImages = [UIImage]()
    @State var imageDictionary = [String:UIImage]()
    @State var imageList = [UIImage]()
    @State var filteredImageDictionary = [String:UIImage]()
    @State private var presentAlert = false
    @State private var showNewTrip = false
//    @State private var is
    // Voice Recognition
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var buttonText = "press to record"
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
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
                            
                            
                            let tripNames = model.tripList.map{item in item.tripName + "#" + item.id}
                            ForEach(tripNames, id: \.self) { item in
                                Button(action: {
                                    choiceMade = String(item.split(separator: "#")[0])
                                    chosenTripID = String(item.split(separator: "#")[0])
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
                                model.addTripData(userID: "userID", tripName: tripName, timeAdded: timeStamp())
                                choiceMade = tripName
                                tripName = ""
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
                        Button{(buttonText, action: {
                            isRecording = !isRecording
                            print($isRecording)
                            if (isRecording == true) {
                                buttonText = "press to stop recording"
                                speechRecognizer.reset()
                                speechRecognizer.transcribe()
                            } else {
                                buttonText = "press to record"
                                speechRecognizer.stopTranscribing()
                                notes = notes + " " + speechRecognizer.transcript
                            }
                        })} label: {
                            Image(systemName: "mic")
                        }.tint(.red)

                            
                    }
           
                    HStack{
                        //Upload button
                        if selectedImage != nil {
                            NavigationLink("Post!", destination: ContentView())
                                .simultaneousGesture(TapGesture().onEnded{
                                                     uploadPhoto()
                                                 })
                        }
                    }
                    .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                        // image picker
                        ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                    }
                    .onAppear {
                        retreiveAllPostPhotos()
                    }
                }
                    
            } .navigationBarBackButtonHidden(true)

        }


            
        }

    init() {
    model.getTripNames()
    model.getPosts()
    }
    //timestamp
    func timeStamp() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    func uploadPhoto() {
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
                model.addPostData(file: path,  latitude: 0.0, longitude: 0.0, notes: notes, timeAdded: timeStamp(), tripID: chosenTripID)
                print("adding data succesfully")
                if selectedImage != nil {
                    DispatchQueue.main.async {
                        self.retrievedImages.append(self.selectedImage!)
                    }
                }
                
            }
        }
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
    
    
    
    }



struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


