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
import CoreData

//Variables from the health kit:


struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View
    {
        //VStack
        //{
            /*
            Text("TRANQUIL")
                .font(.system(size: 60, weight: .heavy))
                .bold()
                .foregroundColor(Color.teal)
             */
            
        ScrollView(.vertical)
            {
                VStack(spacing: 15)
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
                        colors: [Color.blue, Color.teal, Color.indigo],
                        backgroundColor: Color.white)
                }
                .padding()
            }
        //}
        //.padding()
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
/*
var lastDay: [stressLevel] = [
    .init(day: "Sun.", dailyAvg: 99),
    .init(day: "Mon.", dailyAvg: 150),
    .init(day: "Tue.", dailyAvg: 85),
    .init(day: "Wed.", dailyAvg: 100),
    .init(day: "Thu.", dailyAvg: 90),
    .init(day: "Fri.", dailyAvg: 74),
    .init(day: "Sat.", dailyAvg: 79)]
 */
var lastDay: [stressLevel] = fill()

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

//Organizing apple watch captures from CoreData:

/*
func fill() -> [stressLevel]
{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[HeartRate]?

    let fetchRequest = NSFetchRequest<HeartRate>(entityName: "HeartRate")
    
    let sort = NSSortDescriptor(key: #keyPath(HeartRate.timestamp), ascending: true)
    fetchRequest.sortDescriptors = [sort]
    do {
        items = try context.fetch(HeartRate.fetchRequest())
    } catch {
        print("Cannot fetch Expenses")
    }
    
    var sunCount = 0
    var sunTotal = 0
    
    var monCount = 0
    var monTotal = 0
    
    var tueCount = 0
    var tueTotal = 0
    
    var wedCount = 0
    var wedTotal = 0
    
    var thuCount = 0
    var thuTotal = 0
    
    var friCount = 0
    var friTotal = 0
    
    var satCount = 0
    var satTotal = 0
    
    ForEach<[HeartRate], ObjectIdentifier, Any>(items!)
    { HeartRate in
        let calendar = Calendar.current
        let date = HeartRate.timestamp
        let weekday = calendar.component(.weekday, from: date!)
        
        
        switch weekday {
            case 1:
                sunTotal += Int(HeartRate.value)
                sunCount += 1
            case 2:
                monTotal += Int(HeartRate.value)
                monCount += 1
            case 3:
                tueTotal += Int(HeartRate.value)
                tueCount += 1
            case 4:
                wedTotal += Int(HeartRate.value)
                wedCount += 1
            case 5:
                thuTotal += Int(HeartRate.value)
                thuCount += 1
            case 6:
                friTotal += Int(HeartRate.value)
                friCount += 1
            case 7:
                satTotal += Int(HeartRate.value)
                satCount += 1
            default:
                print("Other")
        }
    }
    
    var week: [stressLevel] = [
        .init(day: "Sun.", dailyAvg: Double(sunTotal/sunCount)),
        .init(day: "Mon.", dailyAvg: Double(monTotal/monCount)),
        .init(day: "Tue.", dailyAvg: Double(tueTotal/tueCount)),
        .init(day: "Wed.", dailyAvg: Double(wedTotal/wedCount)),
        .init(day: "Thu.", dailyAvg: Double(thuTotal/thuCount)),
        .init(day: "Fri.", dailyAvg: Double(friTotal/friCount)),
        .init(day: "Sat.", dailyAvg: Double(satTotal/satCount))]
    
    return week
}
*/

//I believe this may be working, but it does not diferentiate between the current week
// and the previous week.
func fill() -> [stressLevel] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [HeartRate]?
    let fetchRequest = NSFetchRequest<HeartRate>(entityName: "HeartRate")
    let sort = NSSortDescriptor(key: #keyPath(HeartRate.timestamp), ascending: true)
    fetchRequest.sortDescriptors = [sort]
    do {
        items = try context.fetch(fetchRequest)
    } catch {
        print("Cannot fetch HeartRate")
    }
    
    var totals: [Int] = Array(repeating: 0, count: 7)
    var counts: [Int] = Array(repeating: 0, count: 7)

    let calendar = Calendar.current
    
    items?.forEach { heartRate in
        if let date = heartRate.timestamp {
            let weekday = calendar.component(.weekday, from: date)
            if weekday >= 1 && weekday <= 7 {
                counts[weekday - 1] += 1
                totals[weekday - 1] += Int(heartRate.value)
            }
        }
    }
    
    var week: [stressLevel] = []
    let days = ["Sun.", "Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat."]
    for i in 0..<7 {
        if counts[i] > 0 {
            let avg = totals[i] / counts[i]
            week.append(.init(day: days[i], dailyAvg: Double(avg)))
        }
    }
    
    return week
}

/*
func fill(forCurrentWeek: Bool) -> [stressLevel] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<HeartRate>(entityName: "HeartRate")
    
    let startDate: Date
    let endDate: Date
    if forCurrentWeek {
        // Calculate the start and end dates of the current week
        let calendar = Calendar.current
        let now = Date()
        var startOfCurrentWeek: Date = now
        calendar.dateInterval(of: .weekOfYear, start: &startOfCurrentWeek, interval: nil, for: now)
        startDate = startOfCurrentWeek
        endDate = calendar.date(byAdding: .day, value: 6, to: startOfCurrentWeek)!
    } else {
        // Calculate the start and end dates of the previous week
        let calendar = Calendar.current
        let now = Date()
        var startOfCurrentWeek: Date = now
        calendar.dateInterval(of: .weekOfYear, start: &startOfCurrentWeek, interval: nil, for: now)
        let startOfPreviousWeek = calendar.date(byAdding: .day, value: -7, to: startOfCurrentWeek)!
        startDate = startOfPreviousWeek
        endDate = calendar.date(byAdding: .day, value: 6, to: startOfPreviousWeek)!
    }
    
    // Configure the fetch request to only fetch HeartRate objects within the date range
    let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", startDate as NSDate, endDate as NSDate)
    fetchRequest.predicate = predicate
    
    let sort = NSSortDescriptor(key: #keyPath(HeartRate.timestamp), ascending: true)
    fetchRequest.sortDescriptors = [sort]
    
    let items: [HeartRate]
    do {
        items = try context.fetch(fetchRequest)
    } catch {
        print("Cannot fetch HeartRates")
        return []
    }
    
    // Calculate the daily averages for the selected date range
    var totals: [Int] = Array(repeating: 0, count: 7)
    var counts: [Int] = Array(repeating: 0, count: 7)

    let calendar = Calendar.current
    
    items.forEach { heartRate in
        if let date = heartRate.timestamp {
            let weekday = calendar.component(.weekday, from: date)
            if weekday >= 1 && weekday <= 7 {
                counts[weekday - 1] += 1
                totals[weekday - 1] += Int(heartRate.value)
            }
        }
    }
    
    var week: [stressLevel] = []
    let days = ["Sun.", "Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat."]
    for i in 0..<7 {
        if counts[i] > 0 {
            let avg = totals[i] / counts[i]
            week.append(.init(day: days[i], dailyAvg: Double(avg)))
        }
    }
    return week
}
*/
