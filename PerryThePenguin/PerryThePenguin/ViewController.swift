//
//  ViewController.swift
//  PerryThePenguin
//
//  Created by terry zhen on 11/1/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let camIcon = UIImage(named: "camera.circle.fill")
//        cameraButton.setBackgroundImage(camIcon, for: UIControl.State.normal)
        
        
    }
    
    @IBAction func launchGPS(_ sender: Any) {
        guard (storyboard?.instantiateViewController(identifier: "gps_vc") as? GpsViewController) != nil else{
            return
        }
//        present(gpsvc, animated: true)
    }
    
    @IBAction func launchScan(_ sender: Any) {
        guard (storyboard?.instantiateViewController(identifier: "textspeech_vc") as? TextSpeechViewController) != nil else{
            return
        }
//        present(scanvs, animated: true)
    }
    
    
    
//    @IBAction func launchScan(_ sender: Any) {
//        guard (storyboard?.instantiateViewController(identifier: "textspeech_vc") as? TextSpeechViewController) != nil else{
//            return
//        }
////        present(scanvs, animated: true)
//    }
    
}

