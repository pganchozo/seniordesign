////
////  TextRecognizer.swift
////  PerryThePenguin
////
////  Created by Patricia  Ganchozo on 11/23/20.
////
//
//import UIKit
//import FirebaseMLVision
//
//class TextRecognizer {
//
//    var textRecognizer: VisionTextRecognizer!
//    var returnResult = String()
//
//    func textrecognizer(capturedImage: UIImage) -> String{
//        
//        let vision = Vision.vision()
//        textRecognizer = vision.cloudTextRecognizer()
//        let visionImage = VisionImage(image: capturedImage)
//        
////        textRecognizer.process(visionImage) { (result, error) in self.processResult(from: result, error: error)
////        }
//        
//        textRecognizer.process(visionImage) { (result, error) in guard error == nil, let result = result else { return }
//            
//            
//            var detectedText = ""
//            
//            for feature in result.blocks {
//                for line in feature.lines{
//                    for element in line.elements{
//                        detectedText.append("\(element.text)")
//                    }
//                }
//            }
//            
//            self.returnResult = detectedText
//            print(self.returnResult)
//            
//        }
//        print("fff")
//        print(returnResult)
//        return returnResult
//    }
//    
////    func processResult(from text: VisionText?, error: Error?){
////        guard let result = text else { return }
////
////        let scanview = ScanViewController()
////
////        let textResult = result.text
////        print("---------")
////        print(textResult)
////        print("---------")
////
//////        let resultVC = UIStoryboard(name: "Scan View", bundle: nil)
//////        let controller = resultVC.instantiateViewController(identifier: "scanvc")
//////        show(resultVC, sender: self)
////        scanview.analyzedText = textResult
////    }
//    
//}
//
////extension UIViewController {
////
////
////}
