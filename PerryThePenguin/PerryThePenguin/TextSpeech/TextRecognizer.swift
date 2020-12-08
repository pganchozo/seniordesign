////
////  TextRecognizer.swift
////  PerryThePenguin
////
////  Created by Patricia  Ganchozo on 11/23/20.
////
//
//import FirebaseMLVision
//
//class TextRecognizer {
//
//    var textRecognizer: VisionTextRecognizer!
//    public var textResult = ""
//
//    func textrecognizer(capturedImage: UIImage){
//
//        let vision = Vision.vision()
//        textRecognizer = vision.cloudTextRecognizer()
//
//        let visionImage = VisionImage(image: capturedImage)
//        textRecognizer.process(visionImage) { (result, error) in guard error == nil, let result = result else { return }
//            TextSpeechViewController().scannedText = result.text
//            self.textResult = result.text
//            print(self.textResult)
//            ScanViewController().textResult.text = result.text
//        }
//
////        while textResult == "" {
////            print("1")
////        }
////        print(textResult)
////        return textResult
//    }
//}
