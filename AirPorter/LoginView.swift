//
//  LoginView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/27/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Log In")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                
                // Show error messages if any.
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    viewModel.signIn()
                }, label: {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                
                NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
                    .padding(.top, 8)
                
                Spacer()
            }
            .padding()
        }
    }
}
