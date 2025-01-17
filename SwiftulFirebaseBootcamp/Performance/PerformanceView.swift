//
//  PerformanceView.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 17.01.25.
//

import SwiftUI
import FirebasePerformance

struct PerformanceView: View {
    @State private var title: String = "Some title"
    @State private var trace: Trace? = nil
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                configure()
                downloadProductsAndUploadToFirebase()
                self.trace = Performance.startTrace(name: "performance_screen_time")
            }
    }
    
    private func configure() {
        let trace = Performance.startTrace(name: "performance_view_loading")
        trace?.setValue(title, forAttribute: "func_state")
        
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            trace?.setValue("Started downloading", forAttribute: "func_state")
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            trace?.setValue("Continued downloading", forAttribute: "func_state")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            trace?.setValue("Finished downloading", forAttribute: "func_state")
            
            trace?.stop()
        }
    }
    
    func downloadProductsAndUploadToFirebase() {
        let urlString = "https://dummyjson.com/products"
        guard let url = URL(string: urlString), let metric = HTTPMetric(url: url, httpMethod: .get) else {return}
        
        metric.start()
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let response = response as? HTTPURLResponse {
                    metric.responseCode = response.statusCode
                }
                metric.stop()
            } catch {
                print(error)
                metric.stop()
            }
        }
    }
}

#Preview {
    PerformanceView()
}
