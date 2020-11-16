////
////  ImageToText.swift
////  PerryThePenguin
////
////  Created by Patricia  Ganchozo on 11/10/20.
////
//
//import Foundation
//import UIKit
//import Firebase
//
//class ImageToText {
//   
//    let vision = Vision.vision()
//    var textRecognizer: VisionTextRecognizer!
//    
//    init() {
//      textRecognizer = vision.cloudTextRecognizer()
//    }
//    
//    
//    func process(imageView: UIImage,
//      callback: @escaping (_ text: String) -> Void) {
//            
//      let visionImage = VisionImage(image: imageView)
//     
//      textRecognizer.process(visionImage) { result, error in
//        guard error == nil, let result = result else {
//          // ...
//            print("oops")
//          return
//        }
//        // 5
//        print(result)
//        callback(result.text)
//        
//        
//        let resultText = result.text
//        for block in result.blocks {
//            let blockText = block.text
//            let blockCornerPoints = block.cornerPoints
//            let blockFrame = block.frame
//            for line in block.lines {
//                let lineText = line.text
//                let lineCornerPoints = line.cornerPoints
//                let lineFrame = line.frame
//                for element in line.elements {
//                    let elementText = element.text
//                    let elementCornerPoints = element.cornerPoints
//                    let elementFrame = element.frame
//                }
//            }
//        }
//      }
//    }
//}
