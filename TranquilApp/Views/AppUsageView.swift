//
//  AppUsageView.swift
//  TranquilApp
//
//  Created by Heather Dinh on 3/8/23.
//

import SwiftUI
import SwiftPieChart

struct AppUsageView : View {
    var body : some View {
        PieChartView(
            values: [getTotalJournalCountTimestampsLastTwoWeeks(),
                     getTotalAICountTimestampsLastTwoWeeks(),
                     getTotalBreathingCountTimestampsLastTwoWeeks()],
            names: ["Journals", "Chats", "Breathing"],
            formatter: {value in String(format: "%.0f", value)},
            colors: [TERTARY_TEXT_COLOR, PRIMARY_TEXT_COLOR, QUATERNEY_TEXT_COLOR],
            backgroundColor: BACKGROUND_COLOR)
        .padding()
        .background(BACKGROUND_COLOR)
    }
}

struct AppUsageView_Previews : PreviewProvider {
    
   static var previews : some View {
        AppUsageView()
    }
}
