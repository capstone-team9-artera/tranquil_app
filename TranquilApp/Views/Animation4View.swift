//
//  Animation4View.swift
//  TranquilApp
//
//  Created by Heather Dinh on 2/24/23.
//

import SwiftUI

struct Animation4View: View {
    @Environment(\.presentationMode) var presentationMode
    var name: String = "Default name"
    var breatheInDuration: Double = 8
    var breatheOutDuration: Double = 5
    var holdDuration: Double = 0
    var numRepeats: Int = 5
    @State private var breathExpand = false
    @State private var hold = true
    @State private var circularMotion = false
    @State private var displayHold = false
    @State private var displayBreathOut = false
    @State private var displayBreathIn = false
    @State private var displaySecondHold = false
    @State private var finishText = false
    
    let fillGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 119/255, green: 87/255, blue: 247/255), Color.cyan]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var body: some View {
        let loopDuration =  breatheInDuration + breatheOutDuration
        ZStack {
            BackgroundWavesView(color2: Color(red: 119/255, green: 87/255, blue: 247/255, opacity: 0.5))
        
            VStack (spacing: 50){
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(SECONDARY_TEXT_COLOR)
                }.offset(x: 170, y: -115)
                
                Text(name)
                    .font(.system(size: 30, weight: .medium))
                    .bold()
                    .foregroundColor(SECONDARY_TEXT_COLOR)
                    .offset(y: -90)
                
                ZStack {
                    ZStack {
                        ZStack {
                            fillGradient.clipShape(Circle())
                                .frame(width: 340, height: 340)
                            
                            // exhale
                            Circle()
                                .trim(from: 0, to: 0.38)
                                .stroke(lineWidth: 5)
                                .frame(width: 370, height: 370)
                                .foregroundColor(Color.cyan)
                                .rotationEffect(.degrees(-47))
                            
                            // inhale
                            Circle()
                                .trim(from: 0, to: 0.62)
                                .stroke(lineWidth: 5)
                                .frame(width: 370, height: 370)
                                .foregroundColor(Color(red: 119/255, green: 87/255, blue: 247/255))
                                .rotationEffect(.degrees(90))
                            
                            ZStack {
                                Circle()
                                    .stroke()
                                    .frame(width: 360, height: 360)
                                    .opacity(0)
                                
                                Capsule()
                                    .trim(from: 1/2, to: 1)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.cyan)
                                    .offset(y: 187)
                                    .rotationEffect(.degrees(circularMotion ? 360 : 0))
                                    .onAppear() {
                                        withAnimation(Animation.linear(duration: 13).repeatCount(numRepeats, autoreverses: false)) {
                                            self.circularMotion = true
                                        }
                                    }
                            }
                        }.frame(width: 360, height: 360)
                            .scaleEffect(breathExpand ? 1 : 0.8)
                            .scaleEffect(hold ? 1 : 1)
                            .onAppear() {
                                // 1
                                withAnimation(Animation.linear(duration: breatheInDuration)) {
                                    self.breathExpand.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration)) {
                                    self.breathExpand.toggle()
                                }
                                
                                // 2
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(loopDuration)) {
                                    self.breathExpand.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + loopDuration)) {
                                    self.breathExpand.toggle()
                                }
                                
                                // 3
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(loopDuration * 2)) {
                                    self.breathExpand.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + loopDuration * 2)) {
                                    self.breathExpand.toggle()
                                }
                                
                                // 4
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(loopDuration * 3)) {
                                    self.breathExpand.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + loopDuration * 3)) {
                                    self.breathExpand.toggle()
                                }
                                
                                // 5
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(loopDuration * 4)) {
                                    self.breathExpand.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + loopDuration * 4)) {
                                    self.breathExpand.toggle()
                                }
                            }
                        // text
                        ZStack {
                            Text("Breathe Out")
                                .foregroundColor(Color.white)
                                .bold()
                                .scaleEffect(1)
                                .opacity(displayBreathOut ? 1 : 0)
                                .onAppear() {
                                    // 1
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration + holdDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration + holdDuration + breatheOutDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    
                                    // 2
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration + breatheInDuration + holdDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration + breatheInDuration + holdDuration + breatheOutDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    
                                    // 3
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration * 2 + breatheInDuration + holdDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration * 2 + breatheInDuration + holdDuration + breatheOutDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    
                                    // 4
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration * 3 + breatheInDuration + holdDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration * 3 + breatheInDuration + holdDuration + breatheOutDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    
                                    // 5
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration * 4 + breatheInDuration + holdDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration * 4 + breatheInDuration + holdDuration + breatheOutDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    
                                    
                                }
                            
                            Text("Breathe In")
                                .foregroundColor(Color.white)
                                .bold()
                                .opacity(displayBreathIn ? 1 : 0)
                                .onAppear() {
                                    // 1
                                    withAnimation(Animation.easeIn(duration: 0.4)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    
                                    // 2
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(loopDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration + loopDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    
                                    // 3
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(loopDuration * 2)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration + loopDuration * 2)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    
                                    // 4
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(loopDuration * 3)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration + loopDuration * 3)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    
                                    // 5
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(loopDuration * 4)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration + loopDuration * 4)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    
                                }
                            
                            Text("Great Job")
                                .foregroundColor(Color.white)
                                .bold()
                                .opacity(finishText ? 1 : 0)
                                .onAppear() {
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration * Double(numRepeats))) {
                                        self.finishText.toggle()
                                    }
                                }
                        }
                    }.offset(y: -60)
                }
            }
        }.background(BACKGROUND_COLOR)
    }
}

struct Animation4View_Previews: PreviewProvider {
    static var previews: some View {
        Animation4View()
    }
}

