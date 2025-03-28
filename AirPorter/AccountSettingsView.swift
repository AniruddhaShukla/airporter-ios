//
//  AccountSettingsView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/27/25.
//

import SwiftUI

struct AccountSettingsView: View {
    @StateObject private var viewModel = AccountSettingsViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            VStack {
                // Profile Image
                ZStack {
                    if let photoURL = viewModel.photoURL {
                        AsyncImage(url: photoURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            case .failure:
                                placeholderImage
                            @unknown default:
                                placeholderImage
                            }
                        }
                    } else {
                        placeholderImage
                    }
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                .padding()

                // Display name or email
                if !viewModel.displayName.isEmpty {
                    Text(viewModel.displayName)
                        .font(.title2)
                } else {
                    Text(viewModel.email)
                        .font(.title2)
                }

                // Mimic a list of user info items
                Form {
                    // Additional sections as desired
                    Section {
                        Button("Sign Out") {
                            authViewModel.signOut()
                        }
                        .foregroundColor(.red)
                    }
                    
                    Button("Delete Account") {
                        // We will implement functionality that allows user to delete
                        // their account here.
                    }
                }

                Spacer()
            }
            .navigationTitle("Account Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
        .onChange(of: viewModel.selectedImage) { newImage in
            if let newImage = newImage {
                // Upload to Firebase and update profile photo
                viewModel.updatePhoto(newImage)
            }
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .foregroundColor(.gray)
    }
}
