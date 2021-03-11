//
//  GpsViewController.swift
//  PerryThePenguin
//
//  Created by terry zhen on 11/1/20.
//

import UIKit
import MapKit
import CoreLocation

class GpsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func returnPrevious(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
