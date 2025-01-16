//
//  CrashView.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 16.01.25.
//

import SwiftUI

struct CrashView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Button(action: {
                    let myString: String? = nil
                    let string2 = myString!
                }, label: {
                    Text("Click me 1")
                })
                
                Button(action: {
                    fatalError("This was a fatal crash")
                }, label: {
                    Text("Click me 2")
                })
                
                Button(action: {
                    let array: [String] = []
                    let item = array[0]
                }, label: {
                    Text("Click me 3")
                })
            }
        }
    }
}

#Preview {
    CrashView()
}
