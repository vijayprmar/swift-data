//
//  SwiftDataExampleApp.swift
//  SwiftDataExample
//
//  Created by Vijay Parmar on 09/10/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Expense.self])
    }
}
