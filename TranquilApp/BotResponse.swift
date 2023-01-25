//
//  BotResponse.swift
//  Anxiety_App
//
//  Created by Victoria Reed on 12/3/22.
//

import Foundation

func getBotResponse(message: String ) -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("sad") || tempMessage.contains("stressed") || tempMessage.contains("anxious"){
        return "I'm sorry to hear that, what's wrong? :("
    } else if tempMessage.contains("goodbye"){
        return "Talk to you later!"
    } else if (tempMessage.contains("hi") || tempMessage.contains("hey") || tempMessage.contains("hello")){
        return "Hello! :) What's up"
    } else {
        return "That's cool"
    }
}
