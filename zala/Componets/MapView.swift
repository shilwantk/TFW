//
//  MapView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var name: String
    @State var street: String
    @State var csz: String
    @State var latitude: Double
    @State var longitude: Double
    @State var distance: Double = 15000
    

    @State private var position: MapCameraPosition = .camera(
            .init(centerCoordinate: CLLocationCoordinate2D(latitude: 26.459840, longitude: -80.073750), distance: 15000))
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Location")
                    .style(color: .white, size: .x18, weight: .w700)
                Spacer()
                Image.arrowUp
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 27)
            }.padding(.bottom)
            Text("\(name)\n\(street),\n\(csz)")
                .style(color: Theme.shared.lightBlue, size: .small, weight: .w500)
                .underline(color:Theme.shared.lightBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 12)
            Map(position: $position, interactionModes: .all) {
                Marker(name, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                    .tint(.orange)
            }
            .mapStyle(.standard)
            .frame(width: 350, height: 200)
            .cornerRadius(12, corners: .allCorners)
        }
        .onAppear {
            position = .camera(.init(centerCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), distance: distance))
        }
    }
}
#Preview {
    MapView(name: "The Breakers Hotel & Resort", street: "12345 SW 67 Street", csz: "West Palm Beach, FL 33123", latitude: 26.459840, longitude: -80.073750)
}
