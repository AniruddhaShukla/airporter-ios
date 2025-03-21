//
//  SatelliteMapView.swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 2/9/25.
//

import SwiftUI
import MapKit


struct SatelliteMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var annotations: [MKAnnotation] = []
    var overlays: [MKOverlay] = []
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = .satelliteFlyover // Use satellite imagery
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.addAnnotations(annotations)
        mapView.addOverlays(overlays)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        uiView.removeOverlays(uiView.overlays)
        uiView.addOverlays(overlays)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SatelliteMapView
        init(_ parent: SatelliteMapView) {
            self.parent = parent
        }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

// MKAnnotation is a class-only protocol, so we define CustomAnnotation as a class.
class CustomAnnotation: NSObject, MKAnnotation, Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}
