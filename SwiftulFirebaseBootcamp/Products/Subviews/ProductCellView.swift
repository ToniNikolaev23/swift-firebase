//
//  ProductCellView.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 11.01.25.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width:75, height: 75)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x:0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Price: $" + String(product.price ?? 0))
                Text("Rating: " + String(product.rating ?? 0))
                Text("Category: " + (product.category ?? "n/a"))
                Text("Brand: " + (product.brand ?? "n/a"))
            }
            .font(.callout)
            .foregroundStyle(.secondary)
           
        }
    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "Test", description: "Test", price: 5.5, discountPercentage: 123.2, rating: 32132, stock: 123, brand: "dasdas", category: "dasdas", thumbnail: "dasdad", images: []))
}
