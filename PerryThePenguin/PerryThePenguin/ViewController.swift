//
//  ViewController.swift
//  PerryThePenguin
//
//  Created by terry zhen on 11/1/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func launchGPS(_ sender: Any) {
        guard let gpsvc = storyboard?.instantiateViewController(identifier: "gps_vc") as? GpsViewController else{
            return
        }
        present(gpsvc, animated: true)
    }
    
    @IBAction func launchScan(_ sender: Any) {
        guard let scanvs = storyboard?.instantiateViewController(identifier: "textspeech_vc") as? TextSpeechViewController else{
            return
        }
        present(scanvs, animated: true)
    }
    
}

