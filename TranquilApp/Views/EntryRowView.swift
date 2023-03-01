//
//  MoodRowView.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import SwiftUI

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
                TextEditor(text: $updatedComment)
                    .font(.system(size: 16))
                    .bold()
                    .frame(minHeight: 50)
                    .lineSpacing(10)
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                    }
                    .onChange(of: updatedComment) { value in
                        entryModelController.updateEntryComment(entry: entry, comment: updatedComment)
                    }
                
                Spacer()
                entryImage()
                
                Image(systemName: "square.and.arrow.down")
                    .foregroundColor(SECONDARY_TEXT_COLOR)
                    .onTapGesture {
                        entryModelController.updateEntryComment(entry: entry, comment: updatedComment)
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                    }
            }
            .foregroundColor(entry.emotion.moodColor)
            .background(.white)
            .padding()
        }
        .background(BACKGROUND_COLOR)
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
