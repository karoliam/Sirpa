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

struct Location: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


struct HomeView: View {
    
    @StateObject var locationManager = LocationManager()
    @ObservedObject var model = ViewModel()

    @State var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
        span: MKCoordinateSpan(latitudeDelta: 110, longitudeDelta:110)
    )
    @State var locations=[]
    
    var body: some View {
        ZStack{
            //            Map(coordinateRegion: $locationManager.region, interactionModes: [.all], showsUserLocation: true)
            //            .onAppear(){
            //                MKMapView.appearance().mapType = .hybridFlyover
            //                MKMapView.appearance().pointOfInterestFilter = .excludingAll
            //            }
            
            AreaMap(region: $locationManager.region, markersList: $model.mapMarkers)
            //            MapView(locations: locations, lManager: $locationManager.region)

            VStack{

                Spacer()
                LocationButton{
                    locationManager.requestLocation()
                }
                .frame(width: 180, height: 40)
                .cornerRadius(30)
                .symbolVariant(.fill)
                .foregroundColor(.white)
                Button("pinn"){
                    let loc = model.mapMarkers.randomElement()
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
            
        }

    }
    init(){
        model.getPosts()

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

        return Map(coordinateRegion: binding, showsUserLocation: true, annotationItems: markersList, annotationContent: {item in
            MapMarker(coordinate: item.coordinate)
                
                
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
