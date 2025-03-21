//
//  MapPolylineOverlay.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/9/25.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct MapPolylineOverlay: UIViewRepresentable {
    let polyline: MKPolyline
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .satelliteFlyover
        mapView.delegate = context.coordinator
        mapView.addOverlay(polyline)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer(overlay: overlay)
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3
            return renderer
        }
    }
}
