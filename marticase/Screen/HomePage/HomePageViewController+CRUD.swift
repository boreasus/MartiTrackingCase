//
//  HomePageViewController+CRUD.swift
//  marticase
//
//  Created by safa uslu on 16.05.2024.
//

import MapKit

extension HomePageViewController {
    func saveLocations() {
        let coordinates = userLocationPoints.map { [$0.latitude, $0.longitude] }
        UserDefaults.standard.set(coordinates, forKey: UserDefaultsHelper.savedCoordinates)
        
        var annotationsWithAddresses: [[String: Any]] = []
        for annotation in mapView.annotations {
            let coordinate = annotation.coordinate
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks?.first {
                    let address = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "")"
                    annotationsWithAddresses.append([
                        "latitude": coordinate.latitude,
                        "longitude": coordinate.longitude,
                        "address": address
                    ])
                    UserDefaults.standard.set(annotationsWithAddresses, forKey: UserDefaultsHelper.savedAnnotations)
                }
            }
        }
        
        let polylineSegments = mapView.overlays.compactMap { overlay -> [[Double]]? in
            guard let polyline = overlay as? MKPolyline else { return nil }
            return polyline.coordinates.map { [$0.latitude, $0.longitude] }
        }
        
        UserDefaults.standard.set(polylineSegments, forKey: UserDefaultsHelper.savedPolylineSegments)
    }
    
    func loadLocations() {
        guard let mapView else { return }
        if let savedAnnotations = UserDefaults.standard.array(forKey: UserDefaultsHelper.savedAnnotations) as? [[String: Any]] {
            for annotationData in savedAnnotations {
                if let latitude     = annotationData["latitude"] as? CLLocationDegrees,
                   let longitude    = annotationData["longitude"] as? CLLocationDegrees,
                   let address      = annotationData["address"] as? String {
                    let annotation = CustomAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.address = address
                    mapView.addAnnotation(annotation)
                }
            }
        }

        if let savedPolylineSegments = UserDefaults.standard.array(forKey: UserDefaultsHelper.savedPolylineSegments) as? [[[Double]]] {
            for segment in savedPolylineSegments {
                let coordinates = segment.map { CLLocationCoordinate2D(latitude: $0[0], longitude: $0[1]) }
                let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
                mapView.addOverlay(polyline)
            }
        }
    }

    func addNewPolylineSegment() {
        if userLocationPoints.count >= 2 {
            let newSegment = [userLocationPoints[userLocationPoints.count - 2], userLocationPoints.last!]
            let polyline = MKPolyline(coordinates: newSegment, count: newSegment.count)
            mapView.addOverlay(polyline)
        }
    }
    
    func resetTrackedData() {
        userLocationPoints = []
        currentSessionPoints = []
        previousLocation = nil
        mapView.removeOverlays(mapView.overlays.filter{$0 is MKPolyline})
        mapView.removeAnnotations(mapView.annotations)
        UserDefaults.standard.removeObject(forKey: UserDefaultsHelper.savedCoordinates)
        UserDefaults.standard.removeObject(forKey: UserDefaultsHelper.savedAnnotations)
        UserDefaults.standard.removeObject(forKey: UserDefaultsHelper.savedPolylineSegments)
    }
}

