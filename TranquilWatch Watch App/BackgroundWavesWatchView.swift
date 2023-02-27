//
//  BackgroundWavesWatchView.swift
//  TranquilWatch Watch App
//
//  Created by Victoria Reed on 2/27/23.
//

import Foundation

import SwiftUI

struct BackgroundWavesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let universalSize = UIScreen.main.bounds
    @State var isAnimated = false
    var body: some View {
        ZStack {
            
//            LinearGradient(gradient: Gradient(colors: [Color(red: 67/255, green: 142/255, blue: 247/255),Color(red: 247/255, green: 151/255, blue: 67/255), .white]),
//                           startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 0.7))

            // this one is buggy
//            getSinWave(interval: universalSize.width * 1.5, amplitude: 110, baseline: 65 + universalSize.height/2)
//                .foregroundColor(Color.init(red: 0.2, green: 0.4, blue: 0.7).opacity(0.4))
//                .offset(x: isAnimated ? -1*(universalSize.width ) : 0)
//                .animation(
//                Animation.linear(duration: 5)
//                    .repeatForever(autoreverses: false)
//            )
            
            getSinWave(interval: universalSize.width, amplitude: 200, baseline: 70 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.3, green: 0.6, blue: 1).opacity(0.4))
                .offset(x: isAnimated ? -1*(universalSize.width ) : 0)
            .animation(
                Animation.linear(duration: 11)
                .repeatForever(autoreverses: false)
            )

            getSinWave(interval: universalSize.width * 3, amplitude: 200, baseline: 95 + universalSize.height/2)
                .foregroundColor(Color.black.opacity(0.2))
                .offset(x: isAnimated ? -1*(universalSize.width  * 3) : 0)
            .animation(
                Animation.linear(duration: 4)
                .repeatForever(autoreverses: false)
            )
            
            getSinWave(interval: universalSize.width * 1.2, amplitude: 50, baseline: 75 + universalSize.height/2)
                .foregroundColor(Color.init(red: 0.6, green: 0.9, blue: 1).opacity(0.4))
                .offset(x: isAnimated ? -1*(universalSize.width  * 1.2) : 0)
            .animation(
                Animation.linear(duration: 5)
                .repeatForever(autoreverses: false)
            )


        }.onAppear(){
            self.isAnimated = true
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


