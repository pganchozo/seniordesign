//
//  File.swift
//  seniordesign
//
//  Created by Patricia  Ganchozo on 10/28/20.
//

import SwiftUI

struct scanView: View {
    @State private var showingImagePicker = false
    
    var body: some View {
        CameraViewController()
        VStack {
            
            Button("Select Image") {
                
                self.showingImagePicker = true
            }
        }
        
        if showingImagePicker {
            secondView()
        }
//                .sheet(isPresented: $showingImagePicker) {
//                    CameraViewController()
//                }
    }
}

struct scanView_Previews: PreviewProvider {
    static var previews: some View {
        scanView()
    }
}
