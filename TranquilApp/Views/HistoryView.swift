//
//  HistoryView.swift
//  tranquil
//
//  Created by John Rollinson.
//
import SwiftUI
import SwiftPieChart
import Charts
import UIKit
import HealthKit
import HealthKitUI

//Variables from the health kit:

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View
    {
        VStack (spacing: 15)
        {
            Text("TRANQUIL")
                .font(.system(size: 60, weight: .heavy))
                .bold()
                .foregroundColor(Color.teal)
            
            ScrollView
            {
                VStack
                {
                    let avg: String = String(format: "Current Week: %0.0f", weeklyStressAverage(currentDay))
                    let lastAvg: String = String(format: "Previous Week: %0.0f", weeklyStressAverage(lastDay))
                    
                    Text("Weekly Stress Level Averages: ")
                        .font(.system(size: 24, weight: .heavy))
                        .bold()
                        .foregroundColor(Color.teal)
                    
                    BarChart()
                        .frame(height: 250)
                    HStack
                    {
                        HStack
                        {
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(Color.teal)
                                .frame(width: 20, height: 20)
                            Text(avg)
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(Color.gray)
                        }
                        HStack
                        {
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(Color.accentColor)
                                .frame(width: 20, height: 20)
                            Text(lastAvg)
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(Color.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Application Usage:")
                        .font(.system(size: 24, weight: .heavy))
                        .bold()
                        .foregroundColor(Color.teal)
                    
                    PieChartView(
                        values: [10, 20, 30],
                        names: ["Journals", "Chats", "Breathing"],
                        formatter: {value in String(format: "%.0f", value)},
                        colors: [Color.red, Color.purple, Color.orange],
                        backgroundColor: Color.white)
                }
            }
        }
        .padding()
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

struct stressLevel: Identifiable
{
    var day : String
    var dailyAvg : Double
    var id = UUID()
}

//Previous weeks data.
//Previous day, Daily HRV average.
var lastDay: [stressLevel] = [
    .init(day: "Sun.", dailyAvg: 99),
    .init(day: "Mon.", dailyAvg: 150),
    .init(day: "Tue.", dailyAvg: 85),
    .init(day: "Wed.", dailyAvg: 100),
    .init(day: "Thu.", dailyAvg: 90),
    .init(day: "Fri.", dailyAvg: 74),
    .init(day: "Sat.", dailyAvg: 79)]

//Current weeks data.
//Current day, Daily HRV average.
var currentDay: [stressLevel] = [
    .init(day: "Sun.", dailyAvg: 83),
    .init(day: "Mon.", dailyAvg: 109),
    .init(day: "Tue.", dailyAvg: 78),
    .init(day: "Wed.", dailyAvg: 95),
    .init(day: "Thu.", dailyAvg: 82),
    .init(day: "Fri.", dailyAvg: 60),
    .init(day: "Sat.", dailyAvg: 65)]

let weekData = [
    (period: "Previous Week", data: lastDay),
    (period: "Current Week", data: currentDay)]

//Function to determine the overall average stress level for the last week.
func weeklyStressAverage(_ week: [stressLevel]) -> Double {
    var total = 0.0
    var counter = 1.0
    for stressLevel in week
    {
        total += stressLevel.dailyAvg
        counter += 1.0
    }
    
    return total/counter
}

struct BarChart: View
{
    var body: some View
    {
        Chart
        {
            //Defining data in the bar chart view:
            ForEach(currentDay) { stressLevel in
                BarMark(
                    x: .value("Day of Week", stressLevel.day),
                    y: .value("Average HRV", stressLevel.dailyAvg)
                )
                .foregroundStyle(Color.teal)
                .annotation(position: .overlay, alignment: .center, spacing: 3) {
                    Text("\(stressLevel.dailyAvg, specifier: "%0.0f")")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
            }
            ForEach(lastDay) { stressLevel in
                BarMark(
                    x: .value("Day of Week", stressLevel.day),
                    y: .value("Average HRV", stressLevel.dailyAvg)
                )
                .foregroundStyle(Color.accentColor)
                .annotation(position: .overlay, alignment: .center, spacing: 3) {
                    Text("\(stressLevel.dailyAvg, specifier: "%0.0f")")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

public struct PieChartView: View {
    public let values: [Double]
    public let names: [String]
    public let formatter: (Double) -> String
    
    public var colors: [Color]
    public var backgroundColor: Color
    
    public var widthFraction: CGFloat
    public var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    public init(values:[Double], names: [String], formatter: @escaping (Double) -> String, colors: [Color] = [Color.blue, Color.green, Color.orange], backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0), widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.60){
        self.values = values
        self.names = names
        self.formatter = formatter
        
        self.colors = colors
        self.backgroundColor = backgroundColor
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    ForEach(0..<self.values.count){ i in
                        PieSlice(pieSliceData: self.slices[i])
                            .scaleEffect(self.activeIndex == i ? 1.03 : 1)
                            .animation(Animation.spring())
                    }
                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let radius = 0.5 * widthFraction * geometry.size.width
                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                    self.activeIndex = -1
                                    return
                                }
                                var radians = Double(atan2(diff.x, diff.y))
                                if (radians < 0) {
                                    radians = 2 * Double.pi + radians
                                }
                                
                                for (i, slice) in slices.enumerated() {
                                    if (radians < slice.endAngle.radians) {
                                        self.activeIndex = i
                                        break
                                    }
                                }
                            }
                            .onEnded { value in
                                self.activeIndex = -1
                            }
                    )
                    Circle()
                        .fill(self.backgroundColor)
                        .frame(width: widthFraction * geometry.size.width * innerRadiusFraction, height: widthFraction * geometry.size.width * innerRadiusFraction)
                    
                    VStack {
                        Text(self.activeIndex == -1 ? "Total:" : names[self.activeIndex])
                            .font(.title)
                            .foregroundColor(Color.teal)
                        Text(self.formatter(self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                            .font(.title)
                    }
                    
                }
                PieChartRows(colors: self.colors, names: self.names, values: self.values.map { self.formatter($0) }, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) })
            }
            .background(self.backgroundColor)
            .foregroundColor(Color.accentColor)
        }
    }
}

struct PieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]
    
    var body: some View {
        VStack{
            ForEach(0..<self.values.count){ i in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(self.colors[i])
                        .frame(width: 20, height: 20)
                    Text(self.names[i])
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                        Text(self.percents[i])
                        //Color for text that is in the PieChartRows
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(values: [13, 5, 3], names: ["Journals", "Breathing", "Chats"], formatter: {value in String(format: "%.0f", value)})
    }
}

struct PieSlice: View {
    var pieSliceData: PieSliceData
    
    var midRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    path.move(
                        to: CGPoint(
                            x: width * 0.5,
                            y: height * 0.5
                        )
                    )
                    
                    path.addArc(center: CGPoint(x: width * 0.5, y: height * 0.5), radius: width * 0.5, startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle, endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle, clockwise: false)
                    
                }
                .fill(pieSliceData.color)
                
                Text(pieSliceData.text)
                    .position(
                        x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadians)),
                        y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadians))
                    )
                    //PieSlice Number Colors:
                    .foregroundColor(Color.white)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var text: String
    var color: Color
}

struct PieSlice_Previews: PreviewProvider {
    static var previews: some View {
        PieSlice(pieSliceData: PieSliceData(startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 120.0), text: "30%", color: Color.black))
    }
}

func stress(HRV: Float) -> Float {
    let stress = HRV / 2;
    return stress
}

