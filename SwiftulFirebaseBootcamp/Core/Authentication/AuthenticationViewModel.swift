//
//  AuthenticationViewModel.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 10.01.25.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(userId: authDataResult.uid, isAnonymous: authDataResult.isAnonymous, email: authDataResult.email, photoUrl: authDataResult.photoUrl, dateCreated: Date())
        
        try await UserManager.shared.createNewUser(user: user)
        
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens:tokens)
        let user = DBUser(userId: authDataResult.uid, isAnonymous: authDataResult.isAnonymous, email: authDataResult.email, photoUrl: authDataResult.photoUrl, dateCreated: Date())
        
        try await UserManager.shared.createNewUser(user: user)

    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        
        let user = DBUser(userId: authDataResult.uid, isAnonymous: authDataResult.isAnonymous, email: authDataResult.email, photoUrl: authDataResult.photoUrl, dateCreated: Date())
        
        try await UserManager.shared.createNewUser(user: user)
//        try await UserManager.shared.createNewUser(auth: authDataResult)
    }

}
