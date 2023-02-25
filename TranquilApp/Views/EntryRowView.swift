//
//  MoodRowView.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import SwiftUI

//struct EntryRowView: View {
//    @ObservedObject var entryModelController: EntryModelController
//    var entry: Entry
//
//    var body: some View {
//  ZStack {
//
//  Rectangle().fill(Color(UIColor.systemBackground)).cornerRadius(10).shadow(color: .gray, radius: 5, x: 1, y: 1)
//        HStack {
//            VStack {
//            Text(entry.monthString)
//            Text("\(entry.dayAsInt)")
//            }
//
//
//            Text(entry.comment ?? "No comment made.").font(.title).bold()
//
////                Image(systemName: "pencil")
////                    .foregroundColor(.blue)
////
//            Spacer()
//
//            entryImage()
//
//            }.foregroundColor(entry.emotion.moodColor).padding()
//        }
//    }
//
//    func entryImage() -> some View {
//        var imageName = "none"
//
//        switch entry.emotion.state {
//        case .happy:
//            imageName = "happy"
//        case .meh:
//            imageName = "meh"
//        case .sad:
//            imageName = "sad"
//        }
//        return Image(imageName).resizable().frame(width: 20, height: 20)
//    }
//}
//struct EntryRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryRowView(entryModelController: EntryModelController(), entry: Entry(emotion: Emotion(state: .happy, color: .happyColor), comment: "Test", date: Date()))
//    }
//}

struct EntryRowView: View {
    @ObservedObject var entryModelController: EntryModelController
    var entry: Entry
    @State private var updatedComment: String

    init(entryModelController: EntryModelController, entry: Entry) {
        self.entryModelController = entryModelController
        self.entry = entry
        self._updatedComment = State(initialValue: entry.comment ?? "")
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 1, y: 1)

            HStack {
                VStack {
                    Text(entry.monthString)
                    Text("\(entry.dayAsInt)")
                }
                
                //update entry comment
                TextField("Enter comment", text: $updatedComment, onCommit: {
                    entryModelController.updateEntryComment(entry: entry, comment: updatedComment)
                })
                .font(.title)
                .bold()

                Spacer()
                entryImage()
                
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        updatedComment = entry.comment ?? ""
                    }
            }
            .foregroundColor(entry.emotion.moodColor)
            .padding()
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
