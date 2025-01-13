//
//  FavoriteView.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 13.01.25.
//

import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    
    func getAllFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
        }
    }
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()

            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid ,favoriteProductId: favoriteProductId)
            getAllFavorites()
        }
    }
}

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
        .onAppear{
            viewModel.getAllFavorites()
        }
    }
}

#Preview {
    NavigationStack {
        FavoriteView()
    }
}
