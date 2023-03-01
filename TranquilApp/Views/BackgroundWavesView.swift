//
//  ContentView.swift
//  codeTutorial_sinAnimation
//
//  Created by Christopher Guirguis on 4/25/20.
//  Copyright © 2020 Christopher Guirguis. All rights reserved.
//

import SwiftUI

struct BackgroundWavesView: View {
    @Environment(\.presentationMode) var presentationMode
    var color1: Color = WAVE_DEFAULT_1
    var color2: Color = WAVE_DEFAULT_2
    var color3: Color = WAVE_DEFAULT_3
    
    let universalSize = UIScreen.main.bounds
    @State var isAnimated = false
    var shouldAnimate : Bool = true
    var body: some View {
        ZStack {
            getSinWave(interval: universalSize.width, amplitude: 200, baseline: 70 + universalSize.height/2)
                .foregroundColor(color1)
                .offset(x: isAnimated ? -1*(universalSize.width ) : 0)
            .animation(
                Animation.linear(duration: 11)
                .repeatForever(autoreverses: false)
            )

            getSinWave(interval: universalSize.width * 3, amplitude: 200, baseline: 95 + universalSize.height/2)
                .foregroundColor(color2)
                .offset(x: isAnimated ? -1*(universalSize.width  * 3) : 0)
            .animation(
                Animation.linear(duration: 4)
                .repeatForever(autoreverses: false)
            )
            
            getSinWave(interval: universalSize.width * 1.2, amplitude: 50, baseline: 75 + universalSize.height/2)
                .foregroundColor(color3)
                .offset(x: isAnimated ? -1*(universalSize.width  * 1.2) : 0)
            .animation(
                Animation.linear(duration: 5)
                .repeatForever(autoreverses: false)
            )


        }.onAppear(){
            self.isAnimated = shouldAnimate
        }.background(BACKGROUND_COLOR)
    }
}

func getSinWave(interval:CGFloat, amplitude: CGFloat = 100 ,baseline:CGFloat = UIScreen.main.bounds.height/2) -> Path {
    Path{path in
        path.move(to: CGPoint(x: 0, y: baseline
        ))
        path.addCurve(
            to: CGPoint(x: 1*interval,y: baseline),
            control1: CGPoint(x: interval * (0.35),y: amplitude + baseline),
            control2: CGPoint(x: interval * (0.65),y: -amplitude + baseline)
        )
        path.addCurve(
            to: CGPoint(x: 2*interval,y: baseline),
            control1: CGPoint(x: interval * (1.35),y: amplitude + baseline),
            control2: CGPoint(x: interval * (1.65),y: -amplitude + baseline)
        )
        path.addLine(to: CGPoint(x: 2*interval, y: UIScreen.main.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.height))
        
        
    }

}

