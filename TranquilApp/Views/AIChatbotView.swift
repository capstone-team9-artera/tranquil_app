//
//  AIChatbotView.swift
//  Anxiety_App
//
//  Created by Heather Dinh on 11/20/22.
//


import SwiftUI

struct AIChatbotView: View {
//    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var messageText = ""
    @State var messages: [String] = ["Hi it's Jasmine!☕️ How are you doing today?😌🍃"]
    var body: some View {
        VStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dismiss")
            }
            HStack{
                Text("ChatBot")
                    .font(.largeTitle)
                    .bold()
                Image(systemName:"message")
                    .font(.system(size:26))
                    .foregroundColor(Color.blue)
            }
            ScrollView{
                //messages
                ForEach(messages, id: \.self){ message in if message.contains("[USER]"){
                    let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                    HStack{
                        Spacer()
                        Text(newMessage)
                            .padding()
                            .foregroundColor(.white)
                            .background(.blue.opacity(0.8))
                            .padding(.horizontal, 16)
                            .padding(.bottom, 10)
                    }
                } else{
                    HStack{
                        Text(message)
                            .padding()
                            .background(.gray.opacity(0.15))
                            .padding(.horizontal, 16)
                            .padding(.bottom, 10)
                        Spacer()
                    }
                    
                }
                    
                } .rotationEffect(.degrees(180))
            } .rotationEffect(.degrees(180))
                .background(Color.gray.opacity(0.10))
            HStack{
                TextField("Type something", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onSubmit{
                        sendMessage(message: messageText)
                    }
                Button{
                    //sendMessage
                    sendMessage(message: messageText)
                } label:{
                    Image(systemName: "paperplane.fill" )
                }
                .font(.system(size:26))
                .padding(.horizontal, 10)
            }
            .padding()
        }
        //.padding()
    }
    func sendMessage(message: String){
        withAnimation{
            messages.append("[USER]" + message )
            self.messageText = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            withAnimation{
                messages.append(getBotResponse(message: message))
            }
        }
    }
}

struct AIChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        AIChatbotView()
    }
}
