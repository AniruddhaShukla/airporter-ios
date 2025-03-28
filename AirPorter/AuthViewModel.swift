//
//  AuthViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/27/25.
//


import SwiftUI
import FirebaseAuth

// Unified view model to handle both sign-up and login.
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var isUserLoggedIn: Bool = false

    init() {
        // Check if a user is already signed in when the view model is initialized
        self.isUserLoggedIn = Auth.auth().currentUser != nil

        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.isUserLoggedIn = user != nil
        }
    }

    // Sign up using Firebase Auth.
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                } else {
                    
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                    // Additional sign-up logic can be placed here.
                }
            }
        }
    }
    
    // Sign in using Firebase Auth.
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                } else {
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                    // Additional login logic can be placed here.
                }
            }
        }
    }
}
