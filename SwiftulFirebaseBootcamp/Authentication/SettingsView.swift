//
//  SettingsView.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 5.01.25.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func logout() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "toni.n.stoyanov@icloud.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "123456"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser =  try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
        
    }
    
    func linkAppleAccount() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkApple(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        let email = "tonitest@abv.bg"
        let password = "Hello1234"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
    
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            Button(action: {
                Task {
                    do {
                        try viewModel.logout()
                        showSignInView = true
                    } catch {
                        print("Err \(error)")
                    }
                }
            }, label: {
                Text("Logout")
            })
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print("Err \(error)")
                    }
                }
            } label: {
                Text("Delete account")
            }

            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
         
           
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}


extension SettingsView {
    private var emailSection: some View {
        Section {
            Button(action: {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("RESET")
                    } catch {
                        print("Err \(error)")
                    }
                }
            }, label: {
                Text("Reset password")
            })
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("RESET")
                    } catch {
                        print("Err \(error)")
                    }
                }
            }, label: {
                Text("Update password")
            })
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("RESET")
                    } catch {
                        print("Err \(error)")
                    }
                }
            }, label: {
                Text("Update Email")
            })
        } header : {
            Text("Email functions")
        }
    }
    
    private var anonymousSection: some View {
        Section {
            Button(action: {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                    } catch {
                        print("Err \(error)")
                    }
                }
            }, label: {
                Text("Link Google account")
            })
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                        print("RESET")
                    } catch {
                        print("Err \(error)")
                    }
                }
            }, label: {
                Text("Link Apple account")
            })
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("RESET")
                    } catch {
                        print("Err \(error)")
                    }
                }
            }, label: {
                Text("Link Email account")
            })
        } header : {
            Text("Create account")
        }
    }
}
