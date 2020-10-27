//
//  ContentView.swift
//  seniordesign
//
//  Created by Patricia  Ganchozo on 10/26/20.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSheet = false

      var body: some View {
        
        ZStack {
            Color.blue
            .edgesIgnoringSafeArea(.all)
            Text("WELCOME").font(.system(size:42, weight: .heavy, design: .rounded))
                    .padding()
        }
        
          
        .onAppear(perform: delayText)
        .sheet(isPresented: $showingSheet) {
            secondview()
        }
      }
    
    private func delayText() {
        // Delay of 3.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            showingSheet = true
        }
    }
}


struct secondview: View {
    
    @State private var isScan = false
    @State private var isNavigation = false
    
    var body: some View {
        
        NavigationView {
            HStack {
                VStack{
                    NavigationLink(destination: scanView()) {
                        Text("SCAN")
                    }
                }
                VStack{
                    NavigationLink(destination: gpsView()) {
                        Text("GPS")
                    }
                }
            }
        }
        
//        Button("SCAN") {
//            self.isScan.toggle()
//        }
//        .sheet(isPresented: $isScan) {
//            scanView()
//        }
//
//        Button("NAVIGATION"){
//            self.isNavigation.toggle()
//        }
//        .sheet(isPresented: $isNavigation) {
//            navView()
//        }
    }
    
}

struct scanView: View {
    var body: some View {
        Text("SCAN STUFF")
    }
}

struct gpsView: View {
    var body: some View {
        Text("GPS STUFF")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
