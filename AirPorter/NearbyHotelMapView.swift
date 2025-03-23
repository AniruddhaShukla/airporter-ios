//
//  NearbyHotelMapView..swift
//  AirPorter
//
//  Created by Aniruddha Shukla on 3/22/25.
//

import MapKit
import LinkPresentation
import SwiftUI

struct NearbyHotelMapView: View {
    let hotels: [Hotel]
    @Binding var selectedHotel: Hotel?
    @State var region: MKCoordinateRegion
    let airport: Airport
    
    var body: some View {
        VStack {
            // Map view displaying hotel pins with a custom icon.
            Map(coordinateRegion: $region, annotationItems: hotels) { hotel in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: hotel.lat, longitude: hotel.lon)) {
                    Image(systemName: "bed.double.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.orange)
                        .onTapGesture {
                            selectedHotel = hotel
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .sheet(item: $selectedHotel) { hotel in
                HotelDetailsSheetView(hotel: hotel, airport: airport)
            }
        }
    }
}
