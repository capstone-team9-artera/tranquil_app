//
//  AIChatbotView.swift
//  Anxiety_App
//
//  Created by Samar Khan
//


import SwiftUI
import Combine

struct AIChatbotView: View {
    @State var chatMessages: [ChatMessage] = []
    @State var messageText: String = ""
    let openAIService = OpenAIService()
    @State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ZStack {
            BackgroundWavesView(shouldAnimate: false)
                .offset(x: -25, y: 90)
            
            VStack{
                ScrollView {
                    LazyVStack {
                        ForEach(chatMessages, id: \.id) { message in
                            messageView(message: message)
                        }
                    }
                }
                HStack{
                    TextField("Enter a message", text: $messageText)
                        .padding()
                        .background(.white.opacity(0.7))
                        .cornerRadius(12)
                    Button {
                        sendMessage()
                    } label: {
                        Text ("Send")
                            .foregroundColor(.white)
                            .padding()
                            .background(.black)
                            .cornerRadius(12)
                    }
                }
            }
        }
            
        .padding()
        .background(BACKGROUND_COLOR)
    }
    
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me {Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .me ? BACKGROUND_COLOR : .black)
                .padding()
                .background(message.sender == .me ? SECONDARY_TEXT_COLOR : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.sender == .gpt {Spacer() }
        }
    }
    
    func sendMessage() {
        let myMessage = ChatMessage(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .me)
        chatMessages.append(myMessage)
        openAIService.sendMessage(message: messageText).sink { completion in
                // Handle error
            } receiveValue: { response in
                guard
                    let textResponse = response.choices.first?.text
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                                .union(.init(charactersIn: "\""))
                        )
                else { return }
                let gptMessage = ChatMessage(
                    id: response.id,
                    content: textResponse,
                    dateCreated: Date(),
                    sender: .gpt
                )
                chatMessages.append(gptMessage)
            }
            .store(in: &cancellables)
        
        messageText = ""
        
    }
}

struct AIChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        AIChatbotView()
    }
}

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
    
}

enum MessageSender{
    case me
    case gpt
}


extension ChatMessage{
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Sample Message From me", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From gpt", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From me", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From gpt", dateCreated: Date(), sender: .gpt)
    ]
}
