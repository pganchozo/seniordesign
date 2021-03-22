import UIKit
import MapKit
import CoreLocation
import AVFoundation

class GPS2ViewController: UIViewController {
    
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    

    @IBAction func backButton(_ sender: Any) {
//        present(gpsvc, animated: true)
    }
    var locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D!
//    var stepCoordinate: CLLocationCoordinate2D!
    
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
//    struct Location{
//        static var stepCoordinate: CLLocationCoordinate2D!
//    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent{
            print("LEAVING")
//            self.locationManager = nil
//            var currentCoordinate: CLLocationCoordinate2D!
        //    var stepCoordinate: CLLocationCoordinate2D!
            
            self.steps = [MKRoute.Step]()
//            let speechSynthesizer = AVSpeechSynthesizer()
            
            self.stepCounter = 0
            self.stepCreated = 0
//            self.timer: Timer?
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
                    if(self.activate == 0){
                        self.speak = 1
    //                    print("IN SPEAK")
                    }
                    else{
                        self.speak = 0
                    }
                }
                else{
                    self.getNext = 0
                    self.initialMessage = "\(self.steps[self.stepCounter].instructions)"
                    self.directionsLabel.text = self.initialMessage
                    let speechUtterance = AVSpeechUtterance(string: self.initialMessage)
                    self.speechSynthesizer.speak(speechUtterance)
                    self.stepCounter = self.stepCounter + 1
//                    do{
//                        sleep(1)
//                    }
                    let seconds = 1.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
                        self.getNext = 1
                    }
                }
            }
            else{
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
            
        self.locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })

            self.steps = primaryRoute.steps
//            var skip = 0
//            for i in 0 ..< primaryRoute.steps.count {
//                let step = primaryRoute.steps[i]
//                print(step.distance)
//                if((step.distance < 10 && i == 0) || (skip == 1 && i == 1 && step.distance < 10)){
//                    skip = 1
//                }
//                else{
//                    skip = 0
//                }
//                skip = 1 //Always skip for testing
//                if(skip != 1){
//                    print(step.instructions)
//                    print(step.distance)
//                    let region = CLCircularRegion(center: step.polyline.coordinate,
//                                                  radius: 10,
//                                                  identifier: "\(i)")
//                    print(step.polyline.coordinate)
//                    self.locationManager.startMonitoring(for: region)
//                    let circle = MKCircle(center: region.center, radius: region.radius)
//                    self.mapView.addOverlay(circle)
//                }
//
//            }
//            let x = self.steps[1].distance
            self.stepCreated = 1
//            let x = self.distInFeets
//            let y = Double(round(1000*x)/1000)
//            print("JERE")
//            print(self.distInFeet)
//            let a = self.steps[0].distance
//            let b = Double(round(1000*a)/1000)
//            let initialMessage = "In \(b) meters, \(self.steps[0].instructions) then in \(y) meters, \(self.steps[1].instructions)."
//            Location.stepCoordinate = self.steps[1].polyline.coordinate
//            let coord1 = CLLocation(latitude: self.currentCoordinate.latitude, longitude: self.currentCoordinate.longitude)
//            let coord2 = CLLocation(latitude: self.steps[1].polyline.coordinate.latitude, longitude: self.steps[1].polyline.coordinate.longitude)
//            let distInMeters = coord1.distance(from: coord2)
//            print("Distance: ",distInMeters)
//            let initialMessage = "\(self.steps[0].instructions) then in \(self.distInFeet) feet, \(self.steps[1].instructions)."
//            self.stepCreated = 1
//            self.directionsLabel.text = initialMessage
//            let speechUtterance = AVSpeechUtterance(string: initialMessage)
//            self.speechSynthesizer.speak(speechUtterance)
            self.stepCounter += 1
        }
    }

}

extension GPS2ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.startUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        currentCoordinate = currentLocation.coordinate
//        print("IN HERE")
        mapView.userTrackingMode = .followWithHeading
        
    }
    
    
    
    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print("ENTERED")
//        stepCounter += 1
//        if stepCounter < steps.count {
//            let currentStep = steps[stepCounter]
//            let previousStep = steps[stepCounter-1]
////            Location.stepCoordinate = steps[sstepCounter].polyline.coordinate
//            let x = currentStep.distance
//            let y = Double(round(1000*x)/1000)
//            let message = "\(previousStep.instructions) and in \(y) meters, \(currentStep.instructions)"
//            directionsLabel.text = message
//            let speechUtterance = AVSpeechUtterance(string: message)
//            speechSynthesizer.speak(speechUtterance)
//        } else {
//            let message = "Arrived at destination"
//            directionsLabel.text = message
//            let speechUtterance = AVSpeechUtterance(string: message)
//            speechSynthesizer.speak(speechUtterance)
//            stepCounter = 0
//            locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
//
//        }
//    }
}

extension GPS2ViewController: UISearchBarDelegate {
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

extension GPS2ViewController: MKMapViewDelegate {
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
