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
            secondView()
        }
      }
    
    private func delayText() {
        // Delay of 3.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showingSheet = true
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
