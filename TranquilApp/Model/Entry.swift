//
//  Mood.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import Foundation
import SwiftUI

enum EmotionState: String, Codable {
    case happy
    case meh
    case sad
}

enum MoodColor: String, Codable {
    case mehColor = "mehColor"
    case sadColor = "sadColor"
    case happyColor = "happyColor"
}

struct Emotion: Codable {
    var state: EmotionState
    var color: MoodColor

    var moodColor: Color {
        switch color {
        case .mehColor:
            return Color.black
        case .sadColor:
            return Color(red: 237/255, green: 75/255, blue: 66/255)
        case .happyColor:
            return Color(red: 43/255, green: 179/255, blue: 79/255)
        }
    }
}

struct Entry: Codable, Equatable, Identifiable {
    var id = UUID()
    let emotion: Emotion
    var comment: String?
    let date: Date
    
    init(emotion: Emotion, comment: String?, date: Date) {
        self.emotion = emotion
        self.comment = comment
        self.date = date
    }
    
    var dateString: String {
        dateFormatter.string(from: date)
    }
    
    var monthString: String {

    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "LLL"
    
    let month = dateFormatter1.string(from: date)
    
    return month
    
    }
    
    var dayAsInt: Int {
        let day = Calendar.current.component(.day, from: date)
        return day
    }
    
    var year: String {
        return Calendar.current.component(.year, from: date).description
    }
    
    
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        if lhs.date == rhs.date {
            return true
        } else {
            return false
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()
