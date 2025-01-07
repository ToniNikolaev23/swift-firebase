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
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func logout() throws {
        try AuthenticationManager.shared.signOut()
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
            
            if(viewModel.authProviders.contains(.email)) {
                emailSection
            }
         
           
        }
        .onAppear {
            viewModel.loadAuthProviders()
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
}
