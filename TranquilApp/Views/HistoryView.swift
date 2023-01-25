//
//  HistoryView.swift
//  tranquil
//
//  Created by John Rollinson.
//
import SwiftUI
import Charts
import UIKit
import HealthKit
import HealthKitUI


//var count = 1;
struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack (spacing: 15)
        {
            Text("TRANQUIL")
                .font(.system(size: 60, weight: .heavy))
                .bold()
                .foregroundColor(Color.teal)
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dismiss")
            }
            Spacer()
            BarChart()
                .previewLayout(.sizeThatFits)
            
            Spacer()
            Text("Journals Written:")
                .font(.system(size: 20, weight: .heavy))
                .bold()
                .foregroundColor(Color.teal)
            Spacer()
            Text("Breathing Exercises Completed:")
                .font(.system(size: 20, weight: .heavy))
                .bold()
                .foregroundColor(Color.teal)
            Spacer()
            Text("Average Stress Level:")
                .font(.system(size: 20, weight: .heavy))
                .bold()
                .foregroundColor(Color.teal)
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
    var weeklyAvg : Double
    var id = UUID()
}

//Day of the week, Daily HRV average, Weekly HRV average.
var week: [stressLevel] = [
    .init(day: "Sunday", dailyAvg: 83, weeklyAvg: 75),
    .init(day: "Monday", dailyAvg: 109, weeklyAvg: 75),
    .init(day: "Tuesday", dailyAvg: 78, weeklyAvg: 75),
    .init(day: "Wednesday", dailyAvg: 95, weeklyAvg: 75),
    .init(day: "Thursday", dailyAvg: 82, weeklyAvg: 75),
    .init(day: "Friday", dailyAvg: 60, weeklyAvg: 75),
    .init(day: "Saturday", dailyAvg: 65, weeklyAvg: 75)
]

struct BarChart: View
{
    var body: some View
    {
        Chart
        {
            //Defining data in the chart.
            BarMark(
                x: .value("Day of Week", week[0].day),
                y: .value("Average HRV", week[0].dailyAvg)
            )
            BarMark(
                x: .value("Day of Week", week[1].day),
                y: .value("Average HRV", week[1].dailyAvg)
            )
            BarMark(
                x: .value("Day of Week", week[2].day),
                y: .value("Average HRV", week[2].dailyAvg)
            )
            BarMark(
                x: .value("Day of Week", week[3].day),
                y: .value("Average HRV", week[3].dailyAvg)
            )
            BarMark(
                x: .value("Day of Week", week[4].day),
                y: .value("Average HRV", week[4].dailyAvg)
            )
            BarMark(
                x: .value("Day of Week", week[5].day),
                y: .value("Average HRV", week[5].dailyAvg)
            )
            BarMark(
                x: .value("Day of Week", week[6].day),
                y: .value("Average HRV", week[6].weeklyAvg)
            )
        }
    }
}
