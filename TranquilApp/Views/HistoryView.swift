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

    var body: some View
    {
        ScrollView(.vertical)
            {
                Spacer(minLength: 30)
                VStack(spacing: 30)
                {
                    //Notifications count vs current week HRV averages by day.
                    SwiftUICharts.MultiLineChartView(data: [(groupAnxietyCountsByDay(),
                                                             GradientColor(start: Color.purple, end: Color.blue)),
                                                            ([currentWeek[0].dailyAvg,
                                                              currentWeek[1].dailyAvg,
                                                              currentWeek[2].dailyAvg,
                                                              currentWeek[3].dailyAvg,
                                                              currentWeek[4].dailyAvg,
                                                              currentWeek[5].dailyAvg,
                                                              currentWeek[6].dailyAvg],
                                                             GradientColor(start: Color.blue, end: Color.purple))],
                                                     title: "Notifications vs. HRV",
                                                     style: ChartStyle(backgroundColor: Color.white, accentColor: Color.green, gradientColor: GradientColor(start: Color.green, end: Color.blue), textColor: Color.black, legendTextColor: Color.white, dropShadowColor: Color.white), form: CGSize(width: 350, height: 200), rateValue: 20)
                    
                    HStack (spacing: 10) {
                        
                        //Current week HRV daily averages.
                        BarChartView(data: ChartData(points: [currentWeek[0].dailyAvg,
                                                              currentWeek[1].dailyAvg,
                                                              currentWeek[2].dailyAvg,
                                                              currentWeek[3].dailyAvg,
                                                              currentWeek[4].dailyAvg,
                                                              currentWeek[5].dailyAvg,
                                                              currentWeek[6].dailyAvg]),
                                     title: "Current Week HRV", legend: "M T  W  R   F   S   U",
                                     style: Styles.barChartStyleNeonBlueLight)
                            .scaleEffect(0.9)
                        
                        //Last week HRV daily averages.
                        BarChartView(data: ChartData(points: [lastWeek[0].dailyAvg,
                                                              lastWeek[1].dailyAvg,
                                                              lastWeek[2].dailyAvg,
                                                              lastWeek[3].dailyAvg,
                                                              lastWeek[4].dailyAvg,
                                                              lastWeek[5].dailyAvg,
                                                              lastWeek[6].dailyAvg]),
                                     title: "Last Week HRV", legend: "M T  W  R   F   S   U",
                                     style: Styles.barChartStyleNeonBlueLight)
                            .scaleEffect(0.9)
                    }
                    
                    //NLP daily averages for the current week.
                    SwiftUICharts.LineChartView(data: groupNLPValuesByDay(),
                                                title: "NLP Stress Levels",
                                                legend: "M         T         W         R         F         S         U",
                                                form: CGSize(width: 350, height: 200), rateValue: 10)
                    
                    //Pie chart stuff: application feature usage metrics.
                    NavigationView {
                        ZStack {
                            BACKGROUND_COLOR.edgesIgnoringSafeArea(.all)
                            SwiftUICharts.PieChartView(data: [getTotalJournalCountTimestampsLastTwoWeeks(), getTotalAICountTimestampsLastTwoWeeks(), getTotalBreathingCountTimestampsLastTwoWeeks()], title: "Application Usage", style: Styles.barChartStyleNeonBlueLight, form: CGSize(width: 350, height: 450))
                                .offset(y: -100)
                            
                            NavigationLink(destination: {AppUsageView()}, label: {
                                Text("Further Insights")
                                    .frame(width: 340, height: 380)
                                    .offset(y: 100)
                                    .foregroundColor(Color.black)
                            })
                        }
                        
                    }.frame(width: 400, height: 700)
                        .toolbarBackground(BACKGROUND_COLOR, for: .navigationBar)
                        .onAppear {
                            let appearance = UINavigationBarAppearance()
                            appearance.configureWithOpaqueBackground()
                            appearance.backgroundColor = BACKGROUND_UICOLOR
                            appearance.shadowColor = BACKGROUND_UICOLOR
                            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SECONDARY_TEXT_UICOLOR]
                            let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
                            buttonAppearance.normal.titleTextAttributes = [.foregroundColor: SECONDARY_TEXT_UICOLOR]
                            appearance.buttonAppearance = buttonAppearance

                            UINavigationBar.appearance().scrollEdgeAppearance = appearance
                        }
                }
            }
            .background(BACKGROUND_COLOR)
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
var lastWeek: [stressLevel] = fill(forCurrentWeek: false) // pulled from core data.

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
var currentWeek: [stressLevel] = fill(forCurrentWeek: true) //pulled from core data.

let weekData = [
    (period: "Previous Week", data: lastWeek),
    (period: "Current Week", data: currentWeek)]

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
            ForEach(currentWeek) { stressLevel in
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
            ForEach(lastWeek) { stressLevel in
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

/*
 Heart Rate Variability (HRV) is a measure of the variation in time between successive heartbeats. It can be used as an indicator of the autonomic nervous system function and overall health.

 To calculate HRV from heart rate values, you can use a mathematical formula based on the standard deviation of the intervals between successive heartbeats, also known as R-R intervals.
 
 This would output the calculated HRV value for the given heart rate values. Note that this is a simplified example and there are other factors to consider when calculating HRV, such as the length of the recording period and the frequency domain analysis of the R-R intervals.
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
    
    var dayHeartRates: [[Int]] = Array(repeating: [], count: 7)
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
                        dayHeartRates[weekday - 1].append(Int(heartRate.value))
                    }
                } else {
                    if date >= prevWeekStart && date < weekStart {
                        dayHeartRates[weekday - 1].append(Int(heartRate.value))
                    }
                }
            }
        }
    }
    
    var week: [stressLevel] = []
    let days = ["Sun.", "Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat."]
    
    func calculateHRV(from heartRates: [Int]) -> Double? {
        guard !heartRates.isEmpty else { return nil }
        let sdnn = heartRates.standardDeviation
        let hrv = 20.0 * log10(1000.0 / sdnn!)
        return hrv
    }
    
    for i in 0..<7 {
        let heartRates = dayHeartRates[i]
        let hrv = calculateHRV(from: heartRates)
        week.append(.init(day: days[i], dailyAvg: hrv ?? 0))
    }
    
    return week
}

extension Array where Element == Int {
    var standardDeviation: Double? {
        guard count > 1 else { return nil }
        let mean = Double(reduce(0, +)) / Double(count)
        let variance = reduce(0.0) { $0 + pow(Double($1) - mean, 2) } / Double(count - 1)
        return sqrt(variance)
    }
}

// Function to group NLP values by day and calculate daily averages
func groupNLPValuesByDay() -> [Double] {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Get the start and end dates for the current calendar week
    let calendar = Calendar.current
    let today = Date()
    let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
    let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
    
    var dailyAverages: [Double] = []
    for day in 0..<7 {
        let startOfDay = calendar.date(byAdding: .day, value: day, to: startOfWeek)!
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let fetchRequest: NSFetchRequest<NLPValue> = NLPValue.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", startOfDay as NSDate, endOfDay as NSDate)
        do {
            let nlpValues = try context.fetch(fetchRequest)
            let sum = nlpValues.reduce(0, { $0 + $1.stressValue })
            let count = nlpValues.count > 0 ? Double(nlpValues.count) : 1.0
            let dailyAverage = sum / count
            dailyAverages.append(dailyAverage)
        } catch {
            print("Error fetching NLPValues: \(error)")
        }
    }
    return dailyAverages
}

// Function to group AnxietyCount values by day and calculate daily totals
func groupAnxietyCountsByDay() -> [Double] {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Get the start and end dates for the current calendar week
    let calendar = Calendar.current
    let today = Date()
    let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
    let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
    
    var dailyTotals: [Double] = []
    for day in 0..<7 {
        let startOfDay = calendar.date(byAdding: .day, value: day, to: startOfWeek)!
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let fetchRequest: NSFetchRequest<AnxietyCount> = AnxietyCount.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", startOfDay as NSDate, endOfDay as NSDate)
        do {
            let anxietyCounts = try context.fetch(fetchRequest)
            let dailyTotal = anxietyCounts.reduce(0, { $0 + $1.value })
            dailyTotals.append(Double(dailyTotal))
        } catch {
            print("Error fetching AnxietyCounts: \(error)")
        }
    }
    return dailyTotals
}
