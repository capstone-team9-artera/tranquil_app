//
//  TranquilWatchApp.swift
//  TranquilWatch Watch App
//
//  Created by Victoria Reed on 2/5/23.
//

import SwiftUI

@main
struct TranquilWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            WatchView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
