//
//  CalendarView.swift
//  TranquilApp
//
//  Created by archana neupane on 1/24/23.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS 13.0, *)
public struct CalendarView: View {
    @ObservedObject var entryModelController: EntryModelController
    let startDate: Date
    let monthsToDisplay: Int
    var selectableDays = true
    

    init(start: Date, monthsToShow: Int, daysSelectable: Bool = true, entryController: EntryModelController) {
    self.startDate = start
    self.monthsToDisplay = monthsToShow
    self.selectableDays = daysSelectable
    self.entryModelController = entryController
    }

    public var body: some View {
        
        VStack {
            
            WeekdaysView()
            ScrollView {
                MonthView(entryModelController: entryModelController, month: Month(startDate: startDate, selectableDays: selectableDays))
                if monthsToDisplay > 1 {
                    ForEach(1..<self.monthsToDisplay) {
                        MonthView(entryModelController: self.entryModelController, month: Month(startDate: self.nextMonth(currentMonth: self.startDate, add: $0), selectableDays: self.selectableDays))
                    }
                }
            }
            Spacer()
        }.padding().navigationBarTitle("Calendar", displayMode: .inline)
    }

    func nextMonth(currentMonth: Date, add: Int) -> Date {
        var components = DateComponents()
        components.month = add
        let next = Calendar.current.date(byAdding: components, to: currentMonth)!
        return next
    }


}

@available(OSX 10.15, *)
@available(iOS 13.0, *)
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(start: Date(), monthsToShow: 2, entryController: EntryModelController())
    }
}
