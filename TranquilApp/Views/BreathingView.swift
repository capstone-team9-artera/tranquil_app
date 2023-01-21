//
//  BreathingView.swift
//  TranquilApp
//
//  Created by Heather Dinh on 11/20/22.
//


import SwiftUI

struct BreathingView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack (spacing: 15){
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dismiss")
            }
                Text("Breathing Exercises")
                    .font(.system(size: 35, weight: .heavy))
                    .bold()
                    .foregroundColor(Color.teal)

           }
    }
}

