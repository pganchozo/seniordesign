//
//  ScanViewController.swift
//  PerryThePenguin
//
//  Created by Patricia  Ganchozo on 11/10/20.
//

import UIKit
import FirebaseMLVision

class ScanViewController: UIViewController {
    
    @IBOutlet var scanView: UIView!
    @IBOutlet weak var textResult: UITextView!
    @IBOutlet weak var imageResult: UIImageView!
    
    var scanimage: UIImage!
    var textRecognizer: VisionTextRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageResult.image = UIImage(named: "sampletext")
        
        let vision = Vision.vision()
        textRecognizer = vision.cloudTextRecognizer()
        
        let visionImage = VisionImage(image: imageResult.image!)
        textRecognizer.process(visionImage) { (result, error) in guard error == nil, let result = result else { return }
            
            self.textResult.text = result.text
        }

    }
}
