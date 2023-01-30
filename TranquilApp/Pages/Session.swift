//
//  BreathingView.swift
//  Anxiety_App
//
//  Created by Heather Dinh on 11/20/22.
//


import SwiftUI

struct Session: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var title: String
    var description: String
    var color: Color
    
    init(title: String, description: String, color: Color) {
        self.title = title
        self.description = description
        self.color = color
    }
    
    var body: some View {
        VStack (spacing: 15){
            (Text(title + "\n") + Text(Image(systemName: "play.circle")))
                .font(.system(size: 23))
                .foregroundColor(Color.white)
                .frame(width: 350, height: 600)
                .background(color)
                .cornerRadius(10)
                .bold()
                .shadow(color: Color.gray, radius: 5, x: 3, y: 3)
                .padding()
        }
    }
}

struct Session_Previews: PreviewProvider {
    static var previews: some View {
        Session(title: "My Title", description: "My description", color: Color.teal)
    }
}
