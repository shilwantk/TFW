//
//  MapService.swift
//  zala
//
//  Created by Kyle Carriedo on 5/5/24.
//

import Foundation
import CoreLocation
import MapKit

struct MapService {
    static func openAppleMaps(address: String?, name:String){
        guard let address = address else { return }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks?.first else {
                return
            }
            
            let location = placemarks.location?.coordinate
            
            if let lat = location?.latitude, let lon = location?.longitude{
                let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)))
                destination.name = "\(name) - \(address)"
                
                MKMapItem.openMaps(
                    with: [destination]
                )
            }
        }
    }
}
