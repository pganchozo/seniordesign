//
//  ViewController.swift
//  PerryThePenguin
//
//  Created by terry zhen on 11/1/20.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func launchGPS(_ sender: Any) {
    guard (storyboard?.instantiateViewController(identifier: "gps_vc") as? GpsViewController) != nil else{
    return
    }
    //present(gpsvc, animated: true)
    }
        
    @IBAction func launchScan(_ sender: Any) {
    guard (storyboard?.instantiateViewController(identifier: "textspeech_vc") as? TextSpeechViewController) != nil else{
    return
    }
    //present(scanvs, animated: true)
    }
    
    
    @IBAction func Login(_ sender: Any) {
        guard (storyboard?.instantiateViewController(identifier: "login_vc") as? LoginViewController) != nil else{
            return
        }
    }
}

