import UIKit
import MapKit
import CoreLocation
import AVFoundation

class GpsViewController: UIViewController {
    
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backButton(_ sender: Any) {
//        present(gpsvc, animated: true)
    }
    
    var locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D!
    
    var steps = [MKRoute.Step]()
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var stepCounter = 0
    var stepCreated = 0
    var timer: Timer?
    var distInMeters = 0.00
    var distInFeet = 0.00
    var speak = 1
    var counter = 0
    var activate = 0
    var initialMessage = ""
    var getNext = 1
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent{
            print("LEAVING")
            print("hello")
            
            self.steps = [MKRoute.Step]()
            self.stepCounter = 0
            self.stepCreated = 0
            self.distInMeters = 0.00
            self.distInFeet = 0.00
            self.speak = 0
            self.counter = 0
            self.activate = 1
            self.initialMessage = ""
            self.getNext = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        
        timer =  Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in

            if (self.stepCreated == 1 && self.stepCounter < self.steps.count){
                let coord1 = CLLocation(latitude: self.currentCoordinate.latitude, longitude: self.currentCoordinate.longitude)
                let coord2 = CLLocation(latitude: self.steps[self.stepCounter].polyline.coordinate.latitude, longitude: self.steps[self.stepCounter].polyline.coordinate.longitude)
                self.distInMeters = coord1.distance(from: coord2)
                self.distInFeet = self.distInMeters*3.28084
                let b = Double(round(1000*self.distInFeet)/1000)
                if (self.distInFeet > 35.00 && (self.getNext == 1)){
                    self.initialMessage = "In \(b) feet, \(self.steps[self.stepCounter].instructions)."
                    self.directionsLabel.text = self.initialMessage
    //                self.speak = 0 //Testing to disable speech
                    if(self.speak == 1){
                        let speechUtterance = AVSpeechUtterance(string: self.initialMessage)
                        self.speechSynthesizer.speak(speechUtterance)
                        self.speak = 0
                    }
                    self.counter = self.counter + 1
                    self.activate = self.counter % 100
                    if(self.activate == 0) {
                        self.speak = 1
                    }
                    else { self.speak = 0 }
                }
                else {
                    self.getNext = 0
                    self.initialMessage = "\(self.steps[self.stepCounter].instructions)"
                    
                    self.directionsLabel.text = self.initialMessage
                    let speechUtterance = AVSpeechUtterance(string: self.initialMessage)
                    self.speechSynthesizer.speak(speechUtterance)
                    self.stepCounter = self.stepCounter + 1

                    let seconds = 1.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
                        self.getNext = 1
                    }
                }
            }
            else {
                self.mapView.removeOverlays(self.mapView.overlays)
            }
        }
    }
    
    func getDirections(to destination: MKMapItem) {
        
        let sourcePlacemark = MKPlacemark(coordinate: currentCoordinate)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destination
        directionsRequest.transportType = .walking
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [self] (response, _) in
            guard let response = response else { return }
            guard let primaryRoute = response.routes.first else { return }
            
            self.mapView.addOverlay(primaryRoute.polyline)
            
            self.locationManager.monitoredRegions.forEach( { self.locationManager.stopMonitoring(for: $0) })

            self.steps = primaryRoute.steps

            self.stepCreated = 1
            self.stepCounter += 1
        }
    }

}

extension GpsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.startUpdatingLocation()
        
        guard let currentLocation = locations.first else { return }
        currentCoordinate = currentLocation.coordinate
        mapView.userTrackingMode = .followWithHeading
        
    }
}

extension GpsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        let region = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        localSearchRequest.region = region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (response, _) in
            guard let response = response else { return }
            guard let firstMapItem = response.mapItems.first else { return }
            self.getDirections(to: firstMapItem)
        }
        
    }
}

extension GpsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 10
            return renderer
        }
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.fillColor = .red
            renderer.alpha = 0.3
            return renderer
        }
        
        return MKOverlayRenderer()
    }
}
