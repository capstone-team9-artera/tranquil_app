//
//  ContentView.swift
//  MyWatchApp Watch App
//
//  Created by Victoria Reed on 11/17/22.
//

import SwiftUI
import CoreData
import HealthKit

struct WatchView: View {
    @State var value = 0
    @State var count = 0
    @State var isAnimated = false

    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    private let notify = NotificationHandler()
    @Environment(\.managedObjectContext) private var viewContext
    let healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    private var heartRateVariability = HKUnit(from: "count/min")
    @State var items:[HeartRate]?
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                    VStack {
                            Text("TRANQUIL")
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundColor(SECONDARY_TEXT_COLOR)
                            Image(systemName: "heart.fill")
                            .imageScale(.large)
                                .foregroundColor(SECONDARY_TEXT_COLOR)
                            Text("\(value)")
                            .foregroundColor(SECONDARY_TEXT_COLOR)
                        }
                Path{path in
                    path.move(to: CGPoint(x: 0, y: 70 + geometry.size.height/2))
                    path.addCurve(
                        to: CGPoint(x: geometry.size.width,y: 70 + geometry.size.height/2),
                        control1: CGPoint(x: geometry.size.width * (0.35),y: 200 + 70 + geometry.size.height/2),
                        control2: CGPoint(x: geometry.size.width * (0.65),y: -200 + 70 + geometry.size.height/2)
                        )
                    path.addCurve(
                        to: CGPoint(x: 2*geometry.size.width, y: 70 + geometry.size.height/2),
                        control1: CGPoint(x: geometry.size.width * (1.35),y: 200 + 70 + geometry.size.height/2),
                        control2: CGPoint(x: geometry.size.width * (1.65),y: -200 + 70 + geometry.size.height/2)
                        )
                    path.addLine(to: CGPoint(x: 2*geometry.size.width, y:70 + geometry.size.height))
                    path.addLine(to: CGPoint(x: 0, y: 70 + geometry.size.height))
                }
                .foregroundColor(Color.init(red: 0.3, green: 0.6, blue: 1).opacity(0.4))
                .offset(x: isAnimated ? -1*(geometry.size.width ) : 0)
                .animation(
                    Animation.linear(duration: 11)
                        .repeatForever(autoreverses: false))
                
                Path{path in
                    path.move(to: CGPoint(x: 0, y: 50 + geometry.size.height))
                    path.addCurve(
                        to: CGPoint(x: 1*geometry.size.width * 3,y: 50 + geometry.size.height),
                        control1: CGPoint(x: geometry.size.width * 3 * (0.35),y: 200 + 95 + geometry.size.height),
                        control2: CGPoint(x: geometry.size.width * 3 * (0.65),y: -200 + 95 + geometry.size.height)
                        )
                    path.addCurve(
                        to: CGPoint(x: 6*geometry.size.width,y: 50 + geometry.size.height),
                        control1: CGPoint(x: geometry.size.width * 3 * (1.35),y: 295 + geometry.size.height),
                        control2: CGPoint(x: geometry.size.width * 3 * (1.65),y: -200 + 95 + geometry.size.height)
                        )
                    path.addLine(to: CGPoint(x: 6*geometry.size.width, y: 50 + geometry.size.height))
                    path.addLine(to: CGPoint(x: 0, y: 50 + geometry.size.height))
                }
                .foregroundColor(Color.black.opacity(0.2))
                .offset(x: isAnimated ? -1*(geometry.size.width  * 3) : 0)
                .animation(
                    Animation.linear(duration: 7)
                    .repeatForever(autoreverses: false))
                
                Path{path in
                    path.move(to: CGPoint(x: 0, y: 75 + geometry.size.height/2))
                    path.addCurve(
                        to: CGPoint(x: 1*geometry.size.width * 1.2,y: 75 + geometry.size.height/2),
                        control1: CGPoint(x: geometry.size.width * 1.2 * (0.35),y: 50 + 75 + geometry.size.height/2),
                        control2: CGPoint(x: geometry.size.width * 1.2 * (0.65),y: -50 + 75 + geometry.size.height/2)
                        )
                    path.addCurve(
                        to: CGPoint(x: 2*geometry.size.width * 1.2,y: 75 + geometry.size.height/2),
                        control1: CGPoint(x: geometry.size.width * 1.2 * (1.35),y: 50 + 75 + geometry.size.height/2),
                        control2: CGPoint(x: geometry.size.width * 1.2 * (1.65),y: -50 + 75 + geometry.size.height/2)
                        )
                    path.addLine(to: CGPoint(x: 2*geometry.size.width * 1.2, y:75 + geometry.size.height))
                    path.addLine(to: CGPoint(x: 0, y: 75 + geometry.size.height/2))
                }
                .foregroundColor(Color.init(red: 0.6, green: 0.9, blue: 1).opacity(0.4))
                .offset(x: isAnimated ? -1*(geometry.size.width  * 1.2) : 0)
                .animation(
                    Animation.linear(duration: 5)
                        .repeatForever(autoreverses: false))
            }
        }
        .padding()
        .background(Color.white)
        .onAppear(perform: start)
    }
     func start() {
        if HKHealthStore.isHealthDataAvailable() {
            self.isAnimated = true
            authorizeKit()
            notify.askPermission()
            startHeartRateQuery(quantityTypeIdentifier: .heartRate)
        }
    }
    
    func authorizeKit(){
        // Used to define the identifiers that create quantity type objects.
                let healthKitTypes: Set = [
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
             // Requests permission to save and read the specified data types.
                healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }

    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier){
        // We want data points from our current device
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
                
        // A query that returns changes to the HealthKit store, including a snapshot of new changes and continuous monitoring as a long-running query.
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
                    query, samples, deletedObjects, queryAnchor, error in
                    
        // A sample that represents a quantity, including the value and the units.
        guard let samples = samples as? [HKQuantitySample] else {
                    return
        }
                    
            self.process(samples, type: quantityTypeIdentifier)

        }
                
    // It provides us with both the ability to receive a snapshot of data, and then on subsequent calls, a snapshot of what has changed.
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
                
        query.updateHandler = updateHandler
                
        // query execution
                
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        //   variable initialization
        var lastHeartRate = 0.0
        if samples.count == 1 {
        // cycle and value assignment
            for sample in samples {
                if type == .heartRate{
                    lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
                }
                
                self.value = Int(lastHeartRate)
                let newValue = HeartRate(context: viewContext)
                newValue.timestamp = Date()
                newValue.value = Int64(self.value)

                do {
                    try viewContext.save()
                    count += 1
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
        
        if connectivityManager.notificationMessage != nil{
            print("message ")
            let temp =
            connectivityManager.notificationMessage!.text
            notify.sendNotification()

        } else {
            print("no message ")
        }

    }
    
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        //WatchView()
        WatchView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
