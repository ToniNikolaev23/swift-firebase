//
//  ProductCellViewBuilder.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 13.01.25.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    let productId: String
    @State private var product: Product? = nil
    var body: some View {
        ZStack {
            if let product {
                ProductCellView(product: product)
            }
        }
        .task {
            self.product = try? await ProductsManager.shared.getProduct(productId: productId)
        }
    }
}

#Preview {
    ProductCellViewBuilder(productId: "1")
}
