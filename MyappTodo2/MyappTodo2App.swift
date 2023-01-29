//
//  MyappTodo2App.swift
//  MyappTodo2
//
//  Created by 009kin on 2023/01/28.
//

import SwiftUI

@main
struct MyappTodo2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
