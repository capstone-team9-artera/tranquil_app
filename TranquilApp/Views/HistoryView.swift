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
import SwiftUICharts

//Variables from the health kit:


struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    
    func myFunc (x : Double) -> String {
        return "whattttt"
    }
    
    func printThis() {
        print("wattt")
    }

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
                    
                    Text("Weekly Stress Level Averages")
                        .font(.system(size: 24, weight: .heavy))
                        .bold()
                        .foregroundColor(SECONDARY_TEXT_COLOR)
                    
                    BarChart()
                        .frame(height: 250)
                    
                    HStack
                    {
                        HStack
                        {
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(PRIMARY_TEXT_COLOR)
                                .frame(width: 20, height: 20)
                            Text(avg)
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(Color.gray)
                        }
                        HStack
                        {
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(TERTARY_TEXT_COLOR)
                                .frame(width: 20, height: 20)
                            Text(lastAvg)
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(Color.gray)
                        }
                    }
                    
                    Spacer()
                    
                    VStack (spacing : 0) {
                        HStack (spacing: 0) {
                            ZStack {
                                BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Stress Levels", style: Styles.barChartStyleNeonBlueLight)
                                
                                    .offset(x: 0, y: 0)
                                    .scaleEffect(0.85)
                                
//                                Button("what", action: present(AnimationView())
//                                NavigationLink("there", destination: AnimationView())
                                
                            }
                            SwiftUICharts.LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Heart Rate")
                                .offset(x: 0, y: 0)
                                .scaleEffect(0.85)
                        }
                        SwiftUICharts.PieChartView(data: [getTotalJournalCountTimestampsLastTwoWeeks(), getTotalAICountTimestampsLastTwoWeeks(), getTotalBreathingCountTimestampsLastTwoWeeks()], title: "Application Usage", style: Styles.barChartStyleNeonBlueLight)
                            .offset(x: -105, y: 0)
                            .scaleEffect(0.85)
                    }

                    
                    Text("Application Usage")
                        .font(.system(size: 24, weight: .heavy))
                        .bold()
                        .foregroundColor(SECONDARY_TEXT_COLOR)
                    
                    PieChartView(
                        values: [getTotalJournalCountTimestampsLastTwoWeeks(),
                                 getTotalAICountTimestampsLastTwoWeeks(),
                                 getTotalBreathingCountTimestampsLastTwoWeeks()],
                        names: ["Journals", "Chats", "Breathing"],
                        formatter: {value in String(format: "%.0f", value)},
                        colors: [TERTARY_TEXT_COLOR, PRIMARY_TEXT_COLOR, QUATERNEY_TEXT_COLOR],
                        backgroundColor: BACKGROUND_COLOR)
                }
                .padding()
            }
            .background(BACKGROUND_COLOR)
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
//Hard coded for testing.
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
var lastDay: [stressLevel] = fill(forCurrentWeek: false) // pulled from core data.

//Current weeks data.
//Current day, Daily HRV average.
//Hard coded for testing.
/*
var currentDay: [stressLevel] = [
    .init(day: "Sun.", dailyAvg: 83),
    .init(day: "Mon.", dailyAvg: 109),
    .init(day: "Tue.", dailyAvg: 78),
    .init(day: "Wed.", dailyAvg: 95),
    .init(day: "Thu.", dailyAvg: 82),
    .init(day: "Fri.", dailyAvg: 60),
    .init(day: "Sat.", dailyAvg: 65)]
*/
var currentDay: [stressLevel] = fill(forCurrentWeek: true) //pulled from core data.

let weekData = [
    (period: "Previous Week", data: lastDay),
    (period: "Current Week", data: currentDay)]

//Function to determine the overall average stress level for the last week.
func weeklyStressAverage(_ week: [stressLevel]) -> Double {
    var total = 0.0
    var counter = 0.0
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
                .foregroundStyle(SECONDARY_TEXT_COLOR)
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
                .foregroundStyle(SECONDARY_TEXT_COLOR)
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
    public var backgroundColor: Color = BACKGROUND_COLOR
    
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
                            .foregroundColor(SECONDARY_TEXT_COLOR)
                        Text(self.formatter(self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                            .font(.title)
                            .foregroundColor(SECONDARY_TEXT_COLOR)
                    }
                    
                }
                PieChartRows(colors: self.colors, names: self.names, values: self.values.map { self.formatter($0) }, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) })
            }
            .background(self.backgroundColor)
            .foregroundColor(SECONDARY_TEXT_COLOR)
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
        PieChartView(values: [13, 5, 3], names: ["Journals", "Breathing", "Chats"], formatter: {value in String(format: "%.0f", value)}, colors: [TERTARY_TEXT_COLOR, PRIMARY_TEXT_COLOR, QUATERNEY_TEXT_COLOR])
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
*/

func fill(forCurrentWeek: Bool) -> [stressLevel] {
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
    
    let today = Date()
    let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
    let prevWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: weekStart)!
    
    items?.forEach { heartRate in
        if let date = heartRate.timestamp {
            let weekday = calendar.component(.weekday, from: date)
            if weekday >= 1 && weekday <= 7 {
                if forCurrentWeek {
                    if date >= weekStart {
                        counts[weekday - 1] += 1
                        totals[weekday - 1] += Int(heartRate.value)
                    }
                } else {
                    if date >= prevWeekStart && date < weekStart {
                        counts[weekday - 1] += 1
                        totals[weekday - 1] += Int(heartRate.value)
                    }
                }
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

/**
 Calculates the total number of AIcount timestamps in the last 2 weeks and returns it as a double value.
 - Returns: Double value representing the total number of AIcount timestamps in the last 2 weeks.
 */
func getTotalAICountTimestampsLastTwoWeeks() -> Double {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Get the current date and the date 2 weeks ago
    let currentDate = Date()
    guard let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: currentDate) else {
        return 0
    }
    
    // Create a fetch request for AIcount objects with a timestamp in the last 2 weeks
    let fetchRequest = NSFetchRequest<AICount>(entityName: "AICount")
    fetchRequest.predicate = NSPredicate(format: "timestamp > %@", twoWeeksAgo as NSDate)
    
    do {
        // Get the AIcount objects with timestamps in the last 2 weeks
        let aiCounts = try context.fetch(fetchRequest)
        // Return the count of AIcount objects as a Double value
        return Double(aiCounts.count)
    } catch {
        print("Cannot fetch AIcounts")
        return 0
    }
}

/**
 Calculates the total number of BreathingCount timestamps in the last 2 weeks and returns it as a double value.
 - Returns: Double value representing the total number of BreathingCount timestamps in the last 2 weeks.
 */
func getTotalBreathingCountTimestampsLastTwoWeeks() -> Double {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Get the current date and the date 2 weeks ago
    let currentDate = Date()
    guard let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: currentDate) else {
        return 0
    }
    
    // Create a fetch request for BreathingCount objects with a timestamp in the last 2 weeks
    let fetchRequest = NSFetchRequest<BreathingCount>(entityName: "BreathingCount")
    fetchRequest.predicate = NSPredicate(format: "timestamp > %@", twoWeeksAgo as NSDate)
    
    do {
        // Get the BreathingCount objects with timestamps in the last 2 weeks
        let breathingCounts = try context.fetch(fetchRequest)
        // Return the count of BreathingCount objects as a Double value
        return Double(breathingCounts.count)
    } catch {
        print("Cannot fetch BreathingCounts")
        return 0
    }
}

/**
 Calculates the total number of JournalCount timestamps in the last 2 weeks and returns it as a double value.
 - Returns: Double value representing the total number of JournalCount timestamps in the last 2 weeks.
 */
func getTotalJournalCountTimestampsLastTwoWeeks() -> Double {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Get the current date and the date 2 weeks ago
    let currentDate = Date()
    guard let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: currentDate) else {
        return 0
    }
    
    // Create a fetch request for JournalCount objects with a timestamp in the last 2 weeks
    let fetchRequest = NSFetchRequest<JournalCount>(entityName: "JournalCount")
    fetchRequest.predicate = NSPredicate(format: "timestamp > %@", twoWeeksAgo as NSDate)
    
    do {
        let results = try context.fetch(fetchRequest)
        let count = Double(results.count)
        return count
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return 0.0
    }
}



