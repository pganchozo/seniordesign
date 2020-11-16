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
    
    var scantext: String = "helloooo"
    var scanimage: UIImage!
    
    var scannedresult: VisionDocumentText!

    var textRecognizer: VisionDocumentTextRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let vision = Vision.vision()
        textRecognizer = vision.cloudDocumentTextRecognizer()
        
        imageResult.image = UIImage(named: "sampletext")
        print("oops")
//        print(scannedresult.text)
        
//        textResult.text += scannedresult.text
    
        
        let visionImage = VisionImage(image: imageResult.image!)
        textRecognizer.process(visionImage) { (result, error) in guard error == nil, let result = result else { print(error)
            return }
            
            self.textResult.text = result.text
        }

    }
}
