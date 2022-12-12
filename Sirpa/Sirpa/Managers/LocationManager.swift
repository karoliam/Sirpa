import Foundation
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
   private let locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
        span: MKCoordinateSpan(latitudeDelta: 110, longitudeDelta:110)
    )
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(){
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        guard let location = locations.first else {return}
        
        DispatchQueue.main.async {
            self.location = location.coordinate
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            )
        }
        

    }
    
    func randomPinn(pinn:MapMarkers){
        DispatchQueue.main.async {
            self.location = pinn.coordinate
            self.region = MKCoordinateRegion(
                center: pinn.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            )
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
