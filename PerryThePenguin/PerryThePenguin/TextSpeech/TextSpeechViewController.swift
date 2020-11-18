//
//  TextSpeechViewController.swift
//  PerryThePenguin
//
//  Created by Patricia Ganchozo on 10/26/20.
//

import UIKit
import AVFoundation

class TextSpeechViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet var previewView: UIView!
    
//    let result = ScanViewController(nibName: "ScanViewController", bundle: nil)
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var previewing = false
    
    var textRecognizer: VisionTextRecognizer!
    var scannedText: String?
    var capturedImage: UIImage?
    var imagetopass: UIImage?
    
    var metaData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vision = Vision.vision()
        textRecognizer = vision.cloudTextRecognizer()
        
        captureSession = AVCaptureSession()
        captureButton?.layer.cornerRadius = captureButton.frame.size.width / 2
        captureButton?.clipsToBounds = true
        capturePhotoOutput = AVCapturePhotoOutput()

        // Instance of the AVCaptureDevice class to initialize a device object
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        
        if let input = try? AVCaptureDeviceInput(device: captureDevice!) {
            
            if (captureSession!.canAddInput(input)) {
                captureSession!.addInput(input)
                captureSession?.addOutput(capturePhotoOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                videoPreviewLayer?.frame = view.layer.bounds
                previewView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
                
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
    
    }

    override func viewDidLayoutSubviews() {
        videoPreviewLayer?.frame = view.bounds
        if let previewLayer = videoPreviewLayer ,(previewLayer.connection?.isVideoOrientationSupported)! {
            previewLayer.connection?.videoOrientation = UIApplication.shared.statusBarOrientation.videoOrientation ?? .portrait
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onTapTakePhoto(_ sender: Any) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil else{
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
                print("Fail to convert pixel buffer")
                return
            }
        
        // Initialise an UIImage with our image data
        self.capturedImage = UIImage.init(data: imageData , scale: 1.0)
        
        UIImageWriteToSavedPhotosAlbum(capturedImage!, nil, nil, nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ScanViewController {
            let result = segue.destination as! ScanViewController
//            result.finalImage = capturedImage!
            result.scantext = "hello"
        }
    }
}


extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}
