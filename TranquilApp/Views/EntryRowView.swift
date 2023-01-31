//
//  MoodRowView.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import SwiftUI

struct EntryRowView: View {
    var entry: Entry
    
    var body: some View {
  ZStack {
  
  Rectangle().fill(Color(UIColor.systemBackground)).cornerRadius(10).shadow(color: .gray, radius: 5, x: 1, y: 1)
        HStack {
            VStack {
            Text(entry.monthString)
            Text("\(entry.dayAsInt)")
            
            }
            Text(entry.comment ?? "No comment made.").font(.title).bold()
            
            Spacer()
            
            entryImage()
           
            }.foregroundColor(entry.emotion.moodColor).padding()
        }
    }
    
    func entryImage() -> some View {
        var imageName = "none"
        
        switch entry.emotion.state {
        case .happy:
            imageName = "happy"
        case .meh:
            imageName = "meh"
        case .sad:
            imageName = "sad"
        }
        return Image(imageName).resizable().frame(width: 20, height: 20)
    }
}

struct MoodRowView_Previews: PreviewProvider {
    static var previews: some View {
        EntryRowView(entry: Entry(emotion: Emotion(state: .happy, color: .happyColor), comment: "Test", date: Date()))
    }
}
