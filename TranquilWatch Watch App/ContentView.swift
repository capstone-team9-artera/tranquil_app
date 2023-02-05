//
//  ContentView.swift
//  MyWatchApp Watch App
//
//  Created by Victoria Reed on 11/17/22.
//

import SwiftUI
//import CoreData
import HealthKit

struct ContentView: View {
    @State var value = 0
    
    @State var count = 0
    
    
    @Environment(\.managedObjectContext) private var viewContext

    let healthStore = HKHealthStore()
    
    let heartRateQuantity = HKUnit(from: "count/min")
    //@State var items:[HeartRate]?

    var body: some View {
        VStack {
            Image(systemName: "heart")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("\(value)")
            Text("\(count)")

        }
        .padding()
        .onAppear(perform: start)
    }
     func start() {
        if HKHealthStore.isHealthDataAvailable() {
            // Add code to use HealthKit here.
            authorizeKit()
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
        // variable initialization
        var lastHeartRate = 0.0
        
        // cycle and value assignment
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            self.value = Int(lastHeartRate)
//            let newValue = HeartRate(context: viewContext)
//            newValue.timestamp = Date()
//            newValue.value = Int64(self.value)
//
////            do {
////                try viewContext.save()
////                count += 1
////            } catch {
////                let nsError = error as NSError
////                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
////            }
//            let fetchRequest = NSFetchRequest<HeartRate>(entityName: "HeartRate")
//            let sort = NSSortDescriptor(key: #keyPath(HeartRate.timestamp), ascending: true)
//            fetchRequest.sortDescriptors = [sort]
//            do {
//                items = try viewContext.fetch(HeartRate.fetchRequest())
//            } catch {
//                print("Cannot fetch Expenses")
//            }
//            //if lastHeartRate == 0
//
//            let length = items!.count
//            print("Length ", length)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
