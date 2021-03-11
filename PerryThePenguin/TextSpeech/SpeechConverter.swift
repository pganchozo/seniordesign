//
//  SpeechConverter.swift
//  PerryThePenguin
//
//  Created by Patricia  Ganchozo on 3/10/21.
//

import UIKit
import AVFoundation

enum VoiceType: String {
    case undefined
    case waveNetFemale = "en-US-Wavenet-F"
    case waveNetMale = "en-US-Wavenet-D"
    case standardFemale = "en-US-Standard-E"
    case standardMale = "en-US-Standard-D"
}

let ttsAPIurl = "https://texttospeech.googleapis.com/v1/text:synthesize"
let APIKey = "AIzaSyBOURDnReTf8WiZVxaGGuppHnvF2qMcaYY"

class SpeechConverter: NSObject, AVAudioPlayerDelegate {
    
    static let shared = SpeechConverter()
    private(set) var busy: Bool = false
    
    private var player: AVAudioPlayer?
    private var completionHandler: (() -> Void)?
    
    func speak(text: String, voiceType: VoiceType = .waveNetFemale, completion: @escaping () -> Void) {

        guard !self.busy else {
            print("Speech Service busy!")
            return
        }
        
        self.busy = true
        
        DispatchQueue.global(qos: .background).async {
            let post = self.buildPostData(text: text, voiceType: voiceType)
            let header = ["X-Goog-Api-Key": APIKey, "Content-Type": "application/json; charset=utf-8"]
            let response = self.makePostRequest(url: ttsAPIurl, postData: post, header: header)
            
            // get audio content from response
            guard let audioContent = response["audioContent"] as? String else {
                print("Invalid response: \(response)")
                self.busy = false
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            // decode base64 string to Data object
            guard let audioData = Data(base64Encoded: audioContent) else {
                self.busy = false
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.completionHandler = completion
                self.player = try! AVAudioPlayer(data: audioData)
                self.player?.delegate = self
                self.player!.play()
            }
        }
    }
    
    private func buildPostData(text: String, voiceType: VoiceType) -> Data {
        
        var voiceParameters: [String: Any] = ["languageCode": "en-US"]
        
        if voiceType != .undefined {
            voiceParameters["name"] = voiceType.rawValue
        }
        
        let parameters: [String: Any] = [
            "input": ["text": text],
            "voice": voiceParameters,
            "audioConfig": ["audioEncoding": "LINEAR16"]
        ]
        
        // converting dictionary to data
        let data = try! JSONSerialization.data(withJSONObject: parameters)
        
        return data
    }
    
    private func makePostRequest(url: String, postData: Data, header: [String: String] = [:]) -> [String: AnyObject] {
        
        var dict: [String: AnyObject] = [:]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        for each in header {
            request.addValue(each.value, forHTTPHeaderField: each.key)
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                dict = json
            }
            
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
                
        return dict
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player?.delegate = nil
        self.player = nil
        self.busy = false
        
        self.completionHandler!()
        self.completionHandler = nil
    }
    
}
