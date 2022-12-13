//
//  HomeView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//
import MapKit
import SwiftUI
import CoreLocationUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct Location: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct AllPostsSheet: View {
    @ObservedObject var model = ViewModel()
    @ObservedObject var timeformatter = TimeFormatter()

    @Environment(\.dismiss) var dismiss
    @State private var notesShown = false


    
    
    var body: some View {
        ZStack {
            
            
            List(model.postList) {
                item in
                ZStack{
                    HStack{
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
            
        }.onAppear {
            model.retreiveAllPostPhotos()
            model.getPosts()
        
    }
    }
    
}



struct HomeView: View {
    
    @State private var isVisible = false
    
    @StateObject var locationManager = LocationManager()
    
    @State var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
        span: MKCoordinateSpan(latitudeDelta: 110, longitudeDelta:110)
    )
    @Binding var markerLocations:[MapMarkers]
    @State var locations = [
        
    ]
    
    var body: some View {
        ZStack{
            //            Map(coordinateRegion: $locationManager.region, interactionModes: [.all], showsUserLocation: true)
            //            .onAppear(){
            //                MKMapView.appearance().mapType = .hybridFlyover
            //                MKMapView.appearance().pointOfInterestFilter = .excludingAll
            //            }
            
            
            AreaMap(region: $locationManager.region, markersList: $markerLocations)
            //            MapView(locations: locations, lManager: $locationManager.region)
            
            VStack{
                if let location = locationManager.location{
                    Text("**Current location:**\(location.latitude),\(location.longitude)")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
                Spacer()
                //                LocationButton{
                //                    locationManager.requestLocation()
                //                }
                //                .frame(width: 180, height: 40)
                //                .cornerRadius(30)
                //                .symbolVariant(.fill)
                //                .foregroundColor(.white)
                Button("pinn"){
                    let loc = markerLocations.randomElement()
                    locationManager.randomPinn(pinn: loc ?? MapMarkers(id: "none",
                                                                       coordinate: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
                                                                       file: "none",
                                                                       notes: "none",
                                                                       timeStamp: Timestamp(),
                                                                       tripID: "none",
                                                                       userID: "none"))
                }
            }
            .padding()
            Button("See all posts") {
                isVisible.toggle()
            }.frame(width: 100, height: 100)
                .background(.white)
                .sheet(isPresented: $isVisible) {
                    AllPostsSheet()
                }
        }
    }
}

struct AreaMap: View {
    @Binding var region: MKCoordinateRegion
    @Binding var markersList: [MapMarkers]
    var body: some View {
        let binding = Binding(
            get: { self.region },
            set: { newValue in
                DispatchQueue.main.async {
                    self.region = newValue
                }
            }
        )
        let secondBinding = Binding(
            get: {self.markersList},
            set: {value in
                DispatchQueue.main.async {
                    self.markersList = value
                }
            })
        return Map(coordinateRegion: binding, showsUserLocation: true, annotationItems: secondBinding.wrappedValue, annotationContent: {item in
            MapPin(coordinate: item.coordinate)
            
            
            //            MapAnnotation(coordinate:item.coordinate){
            //                Circle()
            //            }
            //            DispatchQueue.main.async{
            //                MapAnnotation(coordinate:item.coordinate){
            //                    Circle()
            //                }
            //            }
            
        })
        .onAppear(){
            MKMapView.appearance().mapType = .hybridFlyover
            MKMapView.appearance().pointOfInterestFilter = .excludingAll
        }
    }
}

struct AnyMapAnnotationProtocol: MapAnnotationProtocol{
    var _annotationData: _MapAnnotationData
    let value:Any
    
    init<WrappedType:MapAnnotationProtocol>(_ value:WrappedType){
        self.value=value
        _annotationData = value._annotationData
    }
}
