//
//  DayCellView.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS 13.0, *)
struct DayCellView: View {
@ObservedObject var entryModelController: EntryModelController
    @ObservedObject var day: Day

    var body: some View {
        VStack {
        Text(day.dayName).frame(width: 32, height: 32)
            .foregroundColor(day.textColor)
            .background(day.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .clipped()
            .onTapGesture {
                if self.day.disabled == false && self.day.selectableDays {
                    self.day.isSelected.toggle()
                }
        }
        
            entryText()
        
        }.background(day.backgroundColor).clipShape(RoundedRectangle(cornerRadius: 10)).onTapGesture {
                if self.day.disabled == false && self.day.selectableDays {
                    self.day.isSelected.toggle()
                }
        }
    }
    
    func entryText() -> some View {
        var imageName = "none"
        for m in entryModelController.entries {
            if m.monthString == day.monthString && m.dayAsInt == day.dayAsInt && m.year == day.year {
              switch m.emotion.state {
                case .happy:
                    imageName = "happy"
                case .meh:
                    imageName = "meh"
                case .sad:
                    imageName = "sad"
                }
                return Image(imageName).resizable().frame(width: 20, height: 20).opacity(1)
            }
        }
        
        return Image(imageName).resizable().frame(width: 20, height: 20).opacity(0)
    }
}

@available(OSX 10.15, *)
@available(iOS 13.0, *)
struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        DayCellView(entryModelController: EntryModelController(), day: Day(date: Date()))
    }
}
