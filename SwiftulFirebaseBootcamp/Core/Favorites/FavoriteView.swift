//
//  FavoriteView.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 13.01.25.
//

import SwiftUI


struct FavoriteView: View {
    
    @StateObject private var viewModel = FavoriteViewModel()
  
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu {
                        Button(action: {
                            viewModel.removeFromFavorites(favoriteProductId: item.id)
                        }, label: {
                            Text("Remove")
                        })
                    }
            }
        }
        .navigationTitle("Products")
        .onFirstAppear {
            viewModel.addListenerForFavorite()
        }
    }
}

#Preview {
    NavigationStack {
        FavoriteView()
    }
}

