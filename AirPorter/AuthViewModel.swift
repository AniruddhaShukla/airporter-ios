//
//  AuthViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/27/25.
//


import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    
    init() {
        // Check if a user is already signed in
        self.isAuthenticated = Auth.auth().currentUser != nil
        
        // Listen for authentication state changes
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = (user != nil)
            }
        }
    }

    /// Creates a new user with email/password. If firstName or lastName are provided,
    /// we combine them and set `displayName` on the user's Firebase Auth profile.
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isAuthenticated = false
                }
                return
            }
            
            // Successfully created the user. Optionally set displayName.
            if let user = result?.user {
                let displayName = [self.firstName, self.lastName]
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                    .joined(separator: " ")
                
                // If user provided first or last name, update the profile.
                if !displayName.isEmpty {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        DispatchQueue.main.async {
                            if let error = error {
                                self.errorMessage = error.localizedDescription
                            } else {
                                self.isAuthenticated = true
                                self.errorMessage = nil
                            }
                        }
                    }
                } else {
                    // No first/last name provided, just mark as authenticated.
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        self.errorMessage = nil
                    }
                }
            }
        }
    }

    /// Logs in an existing user with email/password.
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                } else {
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                }
            }
        }
    }
    
    /// Signs out the current user.
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
        } catch let error {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
