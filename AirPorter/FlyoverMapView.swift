//
//  FlyoverMapView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/19/25.
//

import Foundation
import UIKit
import SwiftUI
import MapKit
struct FlyoverMapView: UIViewRepresentable {
    let approachStart: CLLocationCoordinate2D
    let startCoordinate: CLLocationCoordinate2D
    let endCoordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .satelliteFlyover
        mapView.isPitchEnabled = true
        mapView.showsBuildings = true
        mapView.showsCompass = false

        // Start the approach phase
        let initialCamera = MKMapCamera(
            lookingAtCenter: approachStart, // Start the approach before the runway
            fromDistance: 5000, // High altitude before descent
            pitch: 30, // Looking down at runway from steep angle
            heading: 33 // Align with runway direction
        )
        mapView.setCamera(initialCamera, animated: false)

        // Begin descent sequence
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animateApproach(mapView: mapView)
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    private func animateApproach(mapView: MKMapView) {
        let descentCamera = MKMapCamera(
            lookingAtCenter: startCoordinate,
            fromDistance: 50.0, // Reduce altitude as we reach the runway start
            pitch: 90, // Reduce pitch angle as we near the ground
            heading: 33
        )

        UIView.animate(withDuration: 10.0, delay: 0, options: [.curveLinear]) {
            mapView.setCamera(descentCamera, animated: true)
        } completion: { _ in
            // Start final landing rollout
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.animateLanding(mapView: mapView)
            }
        }
    }

    private func animateLanding(mapView: MKMapView) {
        let finalLandingCamera = MKMapCamera(lookingAtCenter: endCoordinate,
                                             fromDistance: 50.0,
                                             pitch: 90, heading: 33)

        UIView.animate(withDuration: 10.0, delay: 0, options: [.curveLinear]) {
            mapView.setCamera(finalLandingCamera, animated: true)
        }
        
    }
}

struct FlyoverExperienceView: View {

    let approachStart = CLLocationCoordinate2D(latitude: 40.583136, longitude: -73.815813)  // Initial approach position , -84.391519

    let startCoordinate = CLLocationCoordinate2D(latitude: 40.624327, longitude: -73.783784) // JFK Runway 4L Start , -84.411176

    let endCoordinate = CLLocationCoordinate2D(latitude: 40.640217, longitude: -73.771358)   // JFK Runway 4L End

    
    var body: some View {
        FlyoverMapView(approachStart: approachStart, startCoordinate: startCoordinate, endCoordinate: endCoordinate)
            .edgesIgnoringSafeArea(.all)
    }
}
