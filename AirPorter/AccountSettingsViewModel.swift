//
//  AccountSettingsViewModel.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/27/25.
//


import SwiftUI
import FirebaseAuth
import FirebaseStorage

class AccountSettingsViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var photoURL: URL?
    @Published var selectedImage: UIImage?  // Used for the image picker

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        // Listen for auth state changes to keep displayName/email/photoURL updated
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self, let user = user else { return }
            self.displayName = user.displayName ?? ""
            self.email = user.email ?? ""
            self.photoURL = user.photoURL
        }
    }

    deinit {
        // Remove listener when this view model is deallocated
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    /// Uploads a new profile image to Firebase Storage, then updates the user's profile photoURL.
    func updatePhoto(_ image: UIImage) {
        guard let user = Auth.auth().currentUser else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        // Create a unique reference in Firebase Storage
        let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")

        // Upload image data
        storageRef.putData(imageData, metadata: nil) { [weak self] _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            // Retrieve the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching download URL: \(error.localizedDescription)")
                    return
                }
                guard let url = url else { return }

                // Update user's profile with the new photo URL
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.photoURL = url
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Error updating profile photo: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self?.photoURL = url
                        }
                    }
                }
            }
        }
    }
}