//
//  HomePageViewModel.swift
//  marticase
//
//  Created by safa uslu on 15.05.2024.
//

import Foundation
import MapKit

class HomePageViewModel {
    let padding: Double = 24
    let contentPadding: Double = 12
    
    let buttonHW: Double = 50
    let defaultLatitudinalMetersOnZoom: Double = 500
    let defaultLongitudinalMetersOnZoom: Double = 500
    let buttonCornerRadius: Double = 8
    
    private(set) var willFollowUser = false
    var isTracking = true

    func toggleWillFollowUser() {
        willFollowUser.toggle()
    }

    func formatAddress(from placemark: CLPlacemark) -> String {
        var addressString = ""
        let comma = ", "
        
        if let name = placemark.name {
            addressString += name + comma
        }
        if let thoroughfare = placemark.thoroughfare {
            addressString += thoroughfare + comma
        }
        if let locality = placemark.locality {
            addressString += locality + comma
        }
        if let administrativeArea = placemark.administrativeArea {
            addressString += administrativeArea + comma
        }
        if let postalCode = placemark.postalCode {
            addressString += postalCode
        }
        return addressString
    }
}
