//
//  SwiftulFirebaseBootcampApp.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 5.01.25.
//

import SwiftUI
import Firebase

@main
struct SwiftulFirebaseBootcampApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase")
    }
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
