//
//  MoodRowView.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import SwiftUI

                    //              Button(action: { //update entry comment
                    //                  self.entryModelController.updateEntryComment(entry: entry, comment: entry.comment ?? " ")
                    //                            self.presentationMode.wrappedValue.dismiss()
                    //                        })
//                    {
//                        Image(systemName: "pencil")
//                            .foregroundColor(.blue)
//                    }

struct EntryRowView: View {
    @ObservedObject var entryModelController: EntryModelController
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
struct EntryRowView_Previews: PreviewProvider {
    static var previews: some View {
        EntryRowView(entryModelController: EntryModelController(), entry: Entry(emotion: Emotion(state: .happy, color: .happyColor), comment: "Test", date: Date()))
    }
}

//struct EntryRowView: View {
//    @ObservedObject var entryModelController: EntryModelController
//    var entry: Entry
//    @State private var updatedComment = ""
//
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color(UIColor.systemBackground))
//                .cornerRadius(10)
//                .shadow(color: .gray, radius: 5, x: 1, y: 1)
//
//            HStack {
//                VStack {
//                    Text(entry.monthString)
//                    Text("\(entry.dayAsInt)")
//                }
//
//                Text(updatedComment)
//                    .font(.title)
//                    .bold()
//
//                Spacer()
//
//                Button(action: {
//                    updatedComment = entry.comment ?? ""
//                    entryModelController.updateEntryComment(entry: entry, comment: updatedComment)
//                }) {
//                    Image(systemName: "pencil")
//                        .foregroundColor(.blue)
//                }
//            }
//            .foregroundColor(entry.emotion.moodColor)
//            .padding()
//        }
//    }
