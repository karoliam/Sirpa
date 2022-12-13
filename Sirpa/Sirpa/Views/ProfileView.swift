//
//  ProfileView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//
import MapKit
import CoreLocationUI
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreData

struct ProfileView: View {
    
    
    @ObservedObject var model = ViewModel()
    @ObservedObject var timeformatter = TimeFormatter()

    @State var tripName = ""
    @State var notes = ""
    @State var id = ""
    @State var timeAdded = ""
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    @State var tripID = ""
//    @State var profilePhoto = [UIImage]()
    @State var imageDictionary = [String:UIImage]()
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
            Color(white: 0.07).edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
               
                        Text("\(model.userList.filter{$0.id == getUserID() }.map{$0.username}.first ?? "no username found")")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .frame(alignment: .center)
                                .padding(20)
                              
                        HStack{
                            ForEach(model.profilePhotoDictionary.filter{$0.key == getUserID()}.map{$0.value}, id: \.self) { item in
                                Image(uiImage: item)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            .frame(width: 100, height: 100)
                            .cornerRadius(100)
                          

                            
                                VStack{
                                    Text("Trips")
                                        .fontWeight(.bold)
                                    Text("\(String(model.tripList.filter {$0.userID.contains(getUserID())}.count))")
                                }.padding(20)
                                VStack {
                                    Text("Home country")
                                        .fontWeight(.bold)
                                    Text("\(String(model.userList.filter{$0.id == getUserID() }.map{$0.homeCountry}.first ?? "homeless"))")
                                }
             
                                
                        }

                    Spacer()
              
                    List(model.tripList.filter {
                        $0.userID.contains(getUserID())
                    }) {
                        item in
                        NavigationLink {
                            Text("\(item.tripName)")
                                .font(.title)
                            // posts
                            List(model.postList.filter {
                                $0.tripID.contains(item.id)
                            }) {
                                item in
                                ZStack{
                                                HStack(){
                                                        if(notesShown == true) {
                                                            ForEach(model.imageDictionary.filter{
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
                                                                                 Text("\(timeformatter.formatDate(date: item.timeAdded))")
                                                                                     .padding()
                                                                             }
                                                                         }
                                                                         Spacer()
                                                                         // PROFILE PIC
                                                                         ForEach(model.profilePhotoDictionary.filter{$0.key == getUserID()}.map{$0.value}, id: \.self) { item in
                                                                             Image(uiImage: item)
                                                                                 .resizable()
                                                                                 .frame(width: 100, height: 100)
                                                                         }
                                                                         .frame(width: 80, height: 80)
                                                                         .cornerRadius(100)
                                                                         .padding(.trailing, 125)
                                                                         HStack {
                                                                 
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
                                                     }
                                                                     
                                                            else {
                                                            ForEach(model.imageDictionary.filter{
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
                                }
                                
                                
                                
                            }
                            
                        } label: {
                            Text("\(item.tripName)")
                                .foregroundColor(.black)
                        }
                    
                        
                        
                    }
                
  
        
                }
            }
                .foregroundColor(.white)
            
        }
    }
    

        init() {
            model.getTripNames()
            model.getPosts()
            model.getUserInfo()
            model.retreiveAllPostPhotos()
            model.getProfilePhotos()
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

