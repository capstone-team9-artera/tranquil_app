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
    @State private var breathIn = false
    @State private var breathOut = false
    @State private var hold = true
    @State private var circularMotion = false
    @State private var displayHold = false
    @State private var displayBreathOut = false
    @State private var hideBreathOut = false
    @State private var hideBreathIn = false
    @State private var hideHold = false
    @State private var displaySecondHold = false
    @State private var hideSecondHold = false
    
    let fillGradient = LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var body: some View {
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
//           Spacer()
            
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
                            .foregroundColor(Color.green)
                            .rotationEffect(.degrees(90))
                        
                        // top
                        Capsule()
                            .trim(from: 1/2, to: 1)
                            .frame(width: 20, height: 25)
                            .foregroundColor(Color.white)
                            .rotationEffect(.degrees(180))
                            .offset(y: -187)
                        
                        // right
                        Capsule()
                            .trim(from: 1/2, to: 1)
                            .frame(width: 20, height: 25)
                            .foregroundColor(Color.white)
                            .rotationEffect(.degrees(-90))
                            .offset(x: 187)
                        
                        // left
                        Capsule()
                            .trim(from: 1/2, to: 1)
                            .frame(width: 20, height: 25)
                            .foregroundColor(Color.white)
                            .rotationEffect(.degrees(90))
                            .offset(x: -187)
                        
                        // bottom
                        Capsule()
                            .trim(from: 1/2, to: 1)
                            .frame(width: 20, height: 25)
                            .foregroundColor(Color.white)
                            .offset(y: 187)
                        
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
                                    withAnimation(Animation.linear(duration: 16)) {
                                        self.circularMotion = true
                                    }
                                }
                        }
                    }.frame(width: 360, height: 360)
                        .scaleEffect(breathIn ? 1 : 0.8)
                        .scaleEffect(hold ? 1 : 1)
                        .scaleEffect(breathOut ? 0.8 : 1)
                        .onAppear() {
                            withAnimation(Animation.linear(duration: 4)) {
                                self.breathIn.toggle()
                            }
                            
                            withAnimation(Animation.linear(duration: 4).delay(4)) {
                                self.hold.toggle()
                            }
                            
                            withAnimation(Animation.linear(duration: 4).delay(8)) {
                                self.breathOut.toggle()
                            }
                            
                            withAnimation(Animation.linear(duration: 4).delay(12)) {
                                self.hold.toggle()
                            }
                        }
                    ZStack {
                        Text("Breathe Out")
                            .foregroundColor(Color.white)
                            .scaleEffect(1)
                            .opacity(displayBreathOut ? 1 : 0)
                            .opacity(hideBreathOut ? 0 : 1)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(8)) {
                                    self.displayBreathOut.toggle()
                                }
                                
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(12)) {
                                    self.hideBreathOut.toggle()
                                }
                                
                            }
                        
                        Text("Hold")
                            .foregroundColor(Color.white)
                            .scaleEffect(1)
                            .opacity(displaySecondHold ? 1 : 0)
                            .opacity(hideSecondHold ? 0 : 1)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(12)) {
                                    self.displaySecondHold.toggle()
                                }
                                
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(16)) {
                                    self.hideSecondHold.toggle()
                                }
                                
                            }
                        
                        
                        Text("Hold")
                            .foregroundColor(Color.white)
                            .scaleEffect(1)
                            .opacity(displayHold ? 1 : 0)
                            .opacity(hideHold ? 0 : 1)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(4)) {
                                    self.displayHold.toggle()
                                }
                                
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(8)) {
                                    self.hideHold.toggle()
                                }
                                
                            }
                        
                        Text("Breathe In")
                            .foregroundColor(Color.white)
                            .opacity(hideBreathIn ? 0 : 1)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 0.4).delay(4)) {
                                    self.hideBreathIn.toggle()
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

