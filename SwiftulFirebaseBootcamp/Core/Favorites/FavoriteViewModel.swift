//
//  FavoriteViewModel.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 13.01.25.
//

import Foundation
import Combine

@MainActor
final class FavoriteViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerForFavorite() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else { return }
//        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid) {[weak self] products in
//            self?.userFavoriteProducts = products
//        }
        
        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: {[weak self] products in
                self?.userFavoriteProducts = products
            }
            .store(in: &cancellables)

    }
    
//    func getAllFavorites() {
//        Task {
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
//        }
//    }
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()

            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid ,favoriteProductId: favoriteProductId)
        }
    }
}
