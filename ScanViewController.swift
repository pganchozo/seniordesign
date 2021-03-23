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
    @IBOutlet weak var textResult: UITextView?
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var speakButton: UIButton!
    
    var textRecognizer: VisionTextRecognizer!
    var analyzedText:String = ""
    var imageCaptured = UIImage()
    
    let vision = Vision.vision()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageview.image = imageCaptured

        textRecognizer = vision.cloudTextRecognizer()
        let visionImage = VisionImage(image: imageview.image!)

        textRecognizer.process(visionImage) { (result, error) in guard error == nil, let result = result else {return}

            let detectedText = result.text
            self.textResult!.text = detectedText
        }
    }
    
    @IBAction func didPressSpeakButton(_sender: Any) {
        speakButton.setTitle("...", for: .normal)
        speakButton.isEnabled = false
        speakButton.alpha = 0.6
        
        var voiceType: VoiceType = .undefined
        voiceType = .standardFemale
        
        SpeechConverter.shared.speak(text: (textResult?.text)!, voiceType: voiceType) {
            self.speakButton.isEnabled = true
            self.speakButton.alpha = 1
        }
    }
}
