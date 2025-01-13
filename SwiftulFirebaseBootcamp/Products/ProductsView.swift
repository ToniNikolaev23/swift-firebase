//
//  ProductsView.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 11.01.25.
//

import SwiftUI


struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    var body: some View {
        List {
//            Button(action: {
//                viewModel.getProductsByRating()
//            }, label: {
//                Text("Fetch more")
//            })
            ForEach(viewModel.products) { product in
               ProductCellView(product: product)
                    .contextMenu {
                        Button(action: {
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }, label: {
                            Text("Add to favorites")
                        })
                    }
                
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear{
                            viewModel.getProducts()
                        }
                }
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { filterOption in
                        Button(action: {
                            Task{
                                try? await viewModel.filterSelected(option: filterOption)
                            }
                        }, label: {
                            Text(filterOption.rawValue)
                        })
                    }
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { categoryOption in
                        Button(action: {
                            Task{
                                try? await viewModel.categorySelected(option: categoryOption)
                            }
                        }, label: {
                            Text(categoryOption.rawValue)
                        })
                    }
                }
            }
        })
        .task {
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
