//
//  AddMoodView.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import SwiftUI

struct AddEntryView: View {
    @ObservedObject var entryModelController: EntryModelController
    @Environment(\.presentationMode) var presentationMode
    
    @State var text: String? = nil
    @State private var emotionState: EmotionState = .happy
    @State private var moodColor: MoodColor = .happyColor
    @State private var happyIsSelected = false
    @State private var mehIsSelected = false
    @State private var sadIsSelected = false
    @State private var counterLabel = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Add an Entry").font(.largeTitle)
            HStack {
                Button(action: {
                    self.emotionState = .happy
                    self.moodColor = .happyColor
                    self.happyIsSelected = true
                    self.mehIsSelected = false
                    self.sadIsSelected = false
                }) {
                    Image("happy").resizable().frame(width: 50, height: 50).foregroundColor(.green).background(happyIsSelected ? Color.yellow : Color.clear).clipShape(Circle())
                }
                
                Button(action: {
                    self.emotionState = .meh
                    self.moodColor = .mehColor
                    self.mehIsSelected = true
                    self.happyIsSelected = false
                    self.sadIsSelected = false
                }) {
                    Image("meh").resizable().frame(width: 50, height: 50).foregroundColor(.gray).background(mehIsSelected ? Color.yellow : Color.clear).clipShape(Circle())
                }
                
                Button(action: {
                    self.emotionState = .sad
                    self.moodColor = .sadColor
                    self.sadIsSelected = true
                    self.happyIsSelected = false
                    self.mehIsSelected = false
                }) {
                    Image("sad").resizable().frame(width: 50, height: 50).foregroundColor(.red).background(sadIsSelected ? Color.yellow : Color.clear).clipShape(Circle())
                }
            }
            ZStack(alignment: .bottomTrailing) {
            MultiLineTextField(txt: $text, counterLabel: $counterLabel).frame(height: 450).cornerRadius(20)
//                Text("Remaining: \(counterLabel)").font(.footnote).foregroundColor(.gray).padding([.bottom, .trailing], 8)
        }
            Button(action: {
                    self.entryModelController.createEntry(emotion: Emotion(state: self.emotionState, color: self.moodColor), comment: self.text, date: Date())
                    
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Add Entry").bold().frame(width: UIScreen.main.bounds.width - 30, height: 50).background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }
            Spacer()
        }.padding()
    }

}

struct AddEntryView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        AddEntryView(entryModelController: EntryModelController(), text: "text")
    }
}
