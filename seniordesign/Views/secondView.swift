//
//  secondView.swift
//  seniordesign
//
//  Created by Patricia  Ganchozo on 10/28/20.
//

import SwiftUI

struct secondView: View {
    
    @State private var isScan = false
    @State private var isNavigation = false
    
    var body: some View {
        
        NavigationView {
            HStack {
                VStack{
                    NavigationLink(destination: scanView().edgesIgnoringSafeArea(.top)) {
                        Text("SCAN")
                    }
                }
                VStack{
                    NavigationLink(destination: GPSViewController()) {
                        Text("G")
                    }
                }
            }
        }
        
    }
}


struct secondView_Previews: PreviewProvider {
    static var previews: some View {
        secondView()
    }
}
