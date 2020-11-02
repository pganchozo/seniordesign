////
////  TextSpeechViewController.swift
////  PerryThePenguin
////
////  Created by terry zhen on 11/1/20.
////
//
//import UIKit
//import AVFoundation
//
//final class TextSpeechViewController: UIViewController {
//
//    @IBOutlet weak var Capture: UIButton!
//    @IBOutlet weak var previewView: UIView!
//
//    var captureSesssion : AVCaptureSession!
//    var cameraOutput : AVCapturePhotoOutput!
//    var previewLayer : AVCaptureVideoPreviewLayer!
//    var currentImage: (image: Data, imageName: String)?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        captureSesssion = AVCaptureSession()
//        captureSesssion.sessionPreset = AVCaptureSession.Preset.photo
//        cameraOutput = AVCapturePhotoOutput()
//
//        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//
//
//        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
//
//        if let input = try? AVCaptureDeviceInput(device: device!) {
//            if (captureSesssion.canAddInput(input)) {
//                captureSesssion.addInput(input)
//                if (captureSesssion.canAddOutput(cameraOutput)) {
//                    captureSesssion.addOutput(cameraOutput)
//                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
//                    previewLayer.frame = previewView.bounds
//                    previewView.layer.addSublayer(previewLayer)
//                    captureSesssion.startRunning()
//                }
//            } else {
//                print("issue here : captureSesssion.canAddInput")
//            }
//        } else {
//            print("some problem here")
//        }
//
//        view.addSubview(previewView)
//    }
//}
//
//extension TextSpeechViewController : AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error myerror: Error?) {
//
//        if let myerror = myerror {
//            print("error occure : \(myerror.localizedDescription)")
//        }
//
//        if  let sampleBuffer = photoSampleBuffer,
//            let previewBuffer = previewPhotoSampleBuffer,
//            let dataImage =  AVCapturePhotoOutput
//                .jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
//
//            self.currentImage = (dataImage, "\(resolvedSettings.uniqueID).jpg")
//            showImage()
//        }
//
//    }
//
//    func showImage(){
//        let dataProvider = CGDataProvider(data: self.currentImage!.image as CFData)
//        let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
//        let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
//
//        self.Capture.imageView?.contentMode = .scaleAspectFill
//        self.Capture.setImage(image, for: .normal)
//        self.Capture.isHidden = false
//    }
//}
//
//
//extension TextSpeechViewController {
//    @IBAction func didPressTakePhoto(_ sender: UIButton) {
//            var settings = AVCapturePhotoSettings()
//
//
//            let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
//            let previewFormat = [
//                kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//                kCVPixelBufferWidthKey as String: self.Capture.frame.width,
//                kCVPixelBufferHeightKey as String: self.Capture.frame.height
//            ] as [String : Any]
//            settings.previewPhotoFormat = previewFormat
//
//            cameraOutput.capturePhoto(with: settings, delegate: self)
//        }
//}
//
//
//
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//


//
//  ViewController.swift
//  Camera
//
//  Created by Rizwan on 16/06/17.
//  Copyright © 2017 Rizwan. All rights reserved.
//

import UIKit
import AVFoundation

class TextSpeechViewController: UIViewController {

    
    @IBOutlet weak var captureButton: UIButton!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var qrCodeFrameView: UIView?

    @IBOutlet var previewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        captureSession = AVCaptureSession()
        captureButton?.layer.cornerRadius = captureButton.frame.size.width / 2
        captureButton?.clipsToBounds = true
        
        capturePhotoOutput = AVCapturePhotoOutput()

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
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
        
        
        
        //Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
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
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapTakePhoto(_ sender: Any) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
        
}

extension TextSpeechViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                 previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        
        // Convert photo same buffer to a jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        // Initialise an UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save our captured image to photos album
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Fail to capture photo: \(String(describing: error))")
            return
        }

        guard let imageData = photo.fileDataRepresentation() else {
            print("Fail to convert pixel buffer")
            return
        }

        guard let capturedImage = UIImage.init(data: imageData , scale: 1.0) else {
            print("Fail to convert image data to UIImage")
            return
        }

        let width = capturedImage.size.width
        let height = capturedImage.size.height
        let origin = CGPoint(x: (width - height)/2, y: (height - height)/2)
        let size = CGSize(width: height, height: height)

        guard let imageRef = capturedImage.cgImage?.cropping(to: CGRect(origin: origin, size: size)) else {
            print("Fail to crop image")
            return
        }

        let imageToSave = UIImage(cgImage: imageRef, scale: 1.0, orientation: .down)
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
    }
}

extension TextSpeechViewController : AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                       didOutput metadataObjects: [AVMetadataObject],
                       from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
            }
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
