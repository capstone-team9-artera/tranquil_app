//
//  AnimationView.swift
//  TranquilApp
//
//  Created by Heather Dinh on 2/9/23.
//

import SwiftUI

struct AnimationView: View {
    @Environment(\.presentationMode) var presentationMode
    var name: String = "Default name"
    var breatheInDuration: Double = 4
    var breatheOutDuration: Double = 4
    var holdDuration: Double = 4
    var numRepeats: Int = 2
//    var loopDuration = breatheInDuration + breatheOutDuration + holdDuration * 2
    @State private var breathIn = false
    @State private var breathOut = false
    @State private var hold = true
    @State private var circularMotion = false
    @State private var displayHold = false
    @State private var displayBreathOut = false
    @State private var hideBreathIn = false
    @State private var displaySecondHold = false
    @State private var finishText = false
    
    let fillGradient = LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var body: some View {
        let loopDuration =  breatheInDuration + breatheOutDuration + holdDuration * 2
        VStack (spacing: 50){
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            }.offset(x: 170, y: -115)
            
            Text(name)
                .font(.system(size: 30, weight: .medium))
                .bold()
                .foregroundColor(Color.teal)
            
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
                        
                        // exhale
                        Circle()
                            .trim(from: 0, to: 1/4)
                            .stroke(lineWidth: 5)
                            .frame(width: 370, height: 370)
                            .foregroundColor(Color.cyan)
                            .rotationEffect(.degrees(-90))
                        
                        // inhale
                        Circle()
                            .trim(from: 0, to: 1/4)
                            .stroke(lineWidth: 5)
                            .frame(width: 370, height: 370)
                            .foregroundColor(Color.purple)
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
                                    withAnimation(Animation.linear(duration: 16).repeatCount(numRepeats, autoreverses: false)) {
                                        self.circularMotion = true
                                    }
                                }
                        }
                    }.frame(width: 360, height: 360)
                        .scaleEffect(breathIn ? 1 : 0.8)
                        .scaleEffect(hold ? 1 : 1)
                        .scaleEffect(breathOut ? 0.8 : 1)
                        .onAppear() {
                            withAnimation(Animation.linear(duration: breatheInDuration)) {
                                self.breathIn.toggle()
                            }
                            
                            withAnimation(Animation.linear(duration: holdDuration).delay(breatheInDuration)) {
                                self.hold.toggle()
                            }
                            
                            withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + holdDuration)) {
                                self.breathIn.toggle()
                            }
                            
                            withAnimation(Animation.linear(duration: breatheInDuration).delay(loopDuration)) {
                                self.breathIn.toggle()
                            }
                            
                            withAnimation(Animation.linear(duration: breatheOutDuration).delay(breatheInDuration + holdDuration + loopDuration)) {
                                self.breathIn.toggle()
                            }

                            withAnimation(Animation.linear(duration: holdDuration).delay(breatheInDuration + holdDuration + holdDuration)) {
                                self.hold.toggle()
                            }
                        }
                    // text
                    ZStack {
                        Text("Breathe Out")
                            .foregroundColor(Color.white)
                            .scaleEffect(1)
                            .opacity(displayBreathOut ? 1 : 0)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration + holdDuration)) {
                                    self.displayBreathOut.toggle()
                                }
                                
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration + holdDuration + breatheOutDuration)) {
                                    self.displayBreathOut.toggle()
                                }
                                
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration + breatheInDuration + holdDuration)) {
                                    self.displayBreathOut.toggle()
                                }
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(loopDuration + breatheInDuration + holdDuration + breatheOutDuration)) {
                                    self.displayBreathOut.toggle()
                                }
                            }
                        
                        Text("Hold")
                            .foregroundColor(Color.white)
                            .scaleEffect(1)
                            .opacity(displaySecondHold ? 1 : 0)
                            .onAppear() {
                                withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration + holdDuration + breatheOutDuration)) {
                                    self.displaySecondHold.toggle()
                                }
                                
                                withAnimation(Animation.easeOut(duration: 0.4).delay(loopDuration)) {
                                    self.displaySecondHold.toggle()
                                }
                                
                                withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration + holdDuration + breatheOutDuration + loopDuration)) {
                                    self.displaySecondHold.toggle()
                                }
                                
                                withAnimation(Animation.easeOut(duration: 0.4).delay(loopDuration * 2)) {
                                    self.displaySecondHold.toggle()
                                }
                            }
                        
                        
                        Text("Hold")
                            .foregroundColor(Color.white)
                            .scaleEffect(1)
                            .opacity(displayHold ? 1 : 0)
                            .onAppear() {
                                withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration)) {
                                    self.displayHold.toggle()
                                }
                                
                                withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration + holdDuration)) {
                                    self.displayHold.toggle()
                                }
                                
                                withAnimation(Animation.easeIn(duration: 0.4).delay(breatheInDuration + loopDuration)) {
                                    self.displayHold.toggle()
                                }
                                
                                withAnimation(Animation.easeOut(duration: 0.4).delay(breatheInDuration + holdDuration + loopDuration)) {
                                    self.displayHold.toggle()
                                }
                            }
                        
                        Text("Breathe In")
                            .foregroundColor(Color.white)
                            .opacity(hideBreathIn ? 0 : 1)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(breatheInDuration)) {
                                    self.hideBreathIn.toggle()
                                }
                                withAnimation(Animation.easeIn(duration: 0.4).delay(loopDuration)) {
                                    self.hideBreathIn.toggle()
                                }
                                withAnimation(Animation.easeOut(duration: 0.4).delay(loopDuration + breatheInDuration)) {
                                    self.hideBreathIn.toggle()
                                }
                            }
                        
                        Text("Great Job")
                            .foregroundColor(Color.white)
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

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}

