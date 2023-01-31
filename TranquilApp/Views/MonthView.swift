//
//  MonthView.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS 13.0, *)
struct MonthView: View {

@ObservedObject var entryModelController: EntryModelController
    var month: Month

    var body: some View {
        VStack {
            Text("\(month.monthNameYear)")
            GridStack(rows: month.monthRows, columns: month.monthDays.count) { row, col in
                if self.month.monthDays[col+1]![row].dayDate == Date(timeIntervalSince1970: 0) {
                    Text("").frame(width: 32, height: 32)
                } else {
                    DayCellView(entryModelController: self.entryModelController, day: self.month.monthDays[col+1]![row])
                }

            }
        }
        .padding(.bottom, 20)

    }
}
@available(OSX 10.15, *)
@available(iOS 13.0, *)
struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(entryModelController: EntryModelController(), month: Month(startDate: Date(), selectableDays: true))
    }
}
