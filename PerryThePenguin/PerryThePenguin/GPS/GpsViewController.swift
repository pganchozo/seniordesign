//
//  GpsViewController.swift
//  PerryThePenguin
//
//  Created by terry zhen on 11/1/20.
//

import UIKit
import MapKit
import CoreLocation

class GpsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var AddressField: UITextField!
    @IBOutlet var getDirectionButton: UIButton!
    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.delegate = self
    }
    
    @IBAction func returnPrevious(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func searchPressed(_ sender: Any) {
        getAddress()
    }
    
    func getAddress(){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(AddressField.text!) { (placemarks,error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else{
                    print("No location found!")
                    return
                }
            print(location)
            self.mapThis(destinationCord: location.coordinate)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func mapThis(destinationCord : CLLocationCoordinate2D){
        let sourceCord = (locationManager.location?.coordinate)!
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCord)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destRequest = MKDirections.Request()
        destRequest.source = sourceItem
        destRequest.destination = destItem
        destRequest.transportType = .automobile
        destRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Calculation route wrong")
                }
                return
            }
            //Get first route
            let route = response.routes[0]
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
    
}
