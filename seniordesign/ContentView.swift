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
        
        Text("WELCOME").font(.system(size:42, weight: .heavy, design: .rounded))
                .padding()
          
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
    var body: some View {
        Button("SCAN") {
            self.isScan.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
