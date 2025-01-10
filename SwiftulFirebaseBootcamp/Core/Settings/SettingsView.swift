//
//  SettingsView.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 5.01.25.
//

import SwiftUI

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
