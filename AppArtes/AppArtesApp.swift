//
//  AppArtesApp.swift
//  AppArtes
//
//  Created by Thais Cangucu on 10/04/26.
//

import SwiftUI
import SwiftData

@main
struct AppArtesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ObraDeArte.self)
    }
}
