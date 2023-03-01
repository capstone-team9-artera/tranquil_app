//
//  Animation3View.swift
//  TranquilApp
//
//  Created by Heather Dinh on 2/25/23.
//

import SwiftUI

struct Animation3View: View {
    @Environment(\.presentationMode) var presentationMode
    var name: String = "Default name"
    var breatheInDuration: Double = 3
    var breatheOutDuration: Double = 3
    var numRepeats: Int = 3
    @State private var breathIn = false
    @State private var hold = true
    @State private var circularMotion = false
    @State private var displayHold = false
    @State private var displayBreathOut = false
    @State private var displayBreathIn = false
    @State private var displaySecondHold = false
    @State private var finishText = false
    
    let fillGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 194/255, green: 123/255, blue: 237/255), Color.blue]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var body: some View {
        let loopDuration =  breatheInDuration * 3 +  breatheOutDuration * 3
        ZStack {
            BackgroundWavesView(color2: Color(red: 194/255, green: 123/255, blue: 237/255, opacity: 0.4))
        
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
                
                ZStack {
                    ZStack {
                        ZStack {
                            fillGradient.clipShape(Circle())
                                .frame(width: 340, height: 340)
                            
                            // hold
                            Circle()
                                .stroke(lineWidth: 5)
                                .frame(width: 370, height: 370)
                                .foregroundColor(Color.gray)
                            
                            
                            // inhale 1
                            Circle()
                                .trim(from: 0, to: 1/6)
                                .stroke(lineWidth: 5)
                                .frame(width: 370, height: 370)
                                .foregroundColor(Color(red: 194/255, green: 123/255, blue: 237/255))
                                .rotationEffect(.degrees(90))
                            
                            // inhale 2
                            Circle()
                                .trim(from: 1/3, to: 1/2)
                                .stroke(lineWidth: 5)
                                .frame(width: 370, height: 370)
                                .foregroundColor(Color(red: 194/255, green: 123/255, blue: 237/255))
                                .rotationEffect(.degrees(90))
                            
                            // inhale 3
                            Circle()
                                .trim(from: 2/3, to: 5/6)
                                .stroke(lineWidth: 5)
                                .frame(width: 370, height: 370)
                                .foregroundColor(Color(red: 194/255, green: 123/255, blue: 237/255))
                                .rotationEffect(.degrees(90))
                            
                            // exhale 1
                            Circle()
                                .trim(from: 1/6, to: 1/3)
                                .stroke(lineWidth: 5)
                                .frame(width: 370, height: 370)
                                .foregroundColor(Color.cyan)
                                .rotationEffect(.degrees(-30))
                            
                            // exhale 2
                            Circle()
                                .trim(from: 1/2, to: 2/3)
                                .stroke(lineWidth: 5)
                                .frame(width: 370, height: 370)
                                .foregroundColor(Color.cyan)
                                .rotationEffect(.degrees(-30))
                            
                            // exhale 3
                            Circle()
                                .trim(from: 5/6, to: 1)
                                .stroke(lineWidth: 5)
                                .frame(width: 370, height: 370)
                                .foregroundColor(Color.cyan)
                                .rotationEffect(.degrees(-30))
                            
                            
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
                                        withAnimation(Animation.linear(duration: 18).repeatCount(numRepeats, autoreverses: false)) {
                                            self.circularMotion = true
                                        }
                                    }
                            }
                        }.frame(width: 360, height: 360)
                            .scaleEffect(breathIn ? 1 : 0.8)
                            .scaleEffect(hold ? 1 : 1)
                            .onAppear() {
                                // 1
                                withAnimation(Animation.linear(duration: breatheInDuration)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(breatheInDuration + breatheOutDuration)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + breatheOutDuration + breatheInDuration)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(breatheInDuration * 2 + breatheOutDuration * 2)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration * 2 + breatheOutDuration * 2 + breatheInDuration)) {
                                    self.breathIn.toggle()
                                }
                                
                                
                                
                                // 2
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(loopDuration)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + loopDuration)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(breatheInDuration + breatheOutDuration + loopDuration)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + breatheOutDuration + breatheInDuration + loopDuration)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(breatheInDuration * 2 + breatheOutDuration * 2 + loopDuration)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration * 2 + breatheOutDuration * 2 + breatheInDuration + loopDuration)) {
                                    self.breathIn.toggle()
                                }
                                
                                
                                // 3
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(loopDuration * 2)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + loopDuration * 2)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(breatheInDuration + breatheOutDuration + loopDuration * 2)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + breatheOutDuration + breatheInDuration + loopDuration * 2)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheInDuration).delay(breatheInDuration * 2 + breatheOutDuration * 2 + loopDuration * 2)) {
                                    self.breathIn.toggle()
                                }
                                withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration * 2 + breatheOutDuration * 2 + breatheInDuration + loopDuration * 2)) {
                                    self.breathIn.toggle()
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
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration + breatheOutDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration * 2)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 3 + breatheOutDuration * 2)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 3 + breatheOutDuration * 3)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    
                                    
                                    // 2
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration + breatheInDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration + breatheInDuration + breatheOutDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration + loopDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration * 2 + loopDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 3 + breatheOutDuration * 2 + loopDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 3 + breatheOutDuration * 3 + loopDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    
                                    // 3
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration * 2 + breatheInDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration * 2 + breatheInDuration + breatheOutDuration)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration + loopDuration * 2)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration * 2 + loopDuration * 2)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 3 + breatheOutDuration * 2 + loopDuration * 2)) {
                                        self.displayBreathOut.toggle()
                                    }
                                    withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration * 3 + breatheOutDuration * 3 + loopDuration * 2)) {
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
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration + breatheOutDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration * 2)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration * 3 + breatheOutDuration * 2)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    
                                    
                                    // 2
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(loopDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration + loopDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration + breatheOutDuration + loopDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration + loopDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration * 2 + loopDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration * 3 + breatheOutDuration * 2 + loopDuration)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    
                                    
                                    // 3
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(loopDuration * 2)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration + loopDuration * 2)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration + breatheOutDuration + loopDuration * 2)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration + loopDuration * 2)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration * 2 + breatheOutDuration * 2 + loopDuration * 2)) {
                                        self.displayBreathIn.toggle()
                                    }
                                    withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration * 3 + breatheOutDuration * 2 + loopDuration * 2)) {
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
                    }
                }
            }
        }
    }
    
}

struct Animation3View_Previews: PreviewProvider {
    static var previews: some View {
        Animation3View()
    }
}

