//
//  HomePageViewController+LocationManager.swift
//  marticase
//
//  Created by safa uslu on 16.05.2024.
//

import Foundation
import MapKit

extension HomePageViewController {
    
    func drawLine(locations: [CLLocation]) {
        guard viewModel.isTracking, let location = locations.last else { return }
        currentSessionPoints.append(location.coordinate)
        
        if let lastOverlay = mapView.overlays.last as? MKPolyline,
           lastOverlay.pointCount == currentSessionPoints.count - 1 {
            mapView.removeOverlay(lastOverlay)
        }
        
        let polyline = MKPolyline(coordinates: currentSessionPoints, count: currentSessionPoints.count)
        mapView.addOverlay(polyline)
    }
    
    func followCurrentLocation(where locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters:  viewModel.defaultLatitudinalMetersOnZoom,
                                        longitudinalMeters: viewModel.defaultLongitudinalMetersOnZoom)
        mapView.setRegion(region, animated: true)
    }
    
    func detectEveryHundredMeters(locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if let previousLocation {
            let distance = location.distance(from: previousLocation)
            if distance >= 100 {
                userLocationPoints.append(location.coordinate)
                self.previousLocation = location
                
                var annotation = CustomAnnotation()
                annotation.coordinate = location.coordinate
                annotation = getAdressOfAnnotation(location: location, annotation: annotation)
                mapView.addAnnotation(annotation)
                saveLocations()
            }
        } else {
            userLocationPoints.append(location.coordinate)
            self.previousLocation = location
            saveLocations()
        }
    }
    
    func checkLocationAuthorizationThenZoomInCenter() {
        guard let locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            zoomToCurrentLocation()
        case .denied:
            debugPrint("Konum bilgilerinizi paylaşmayı reddettiniz.")
        case .notDetermined, .restricted:
            debugPrint("Konumunuza erişilmiyor.")
        @unknown default:
            debugPrint("@unknown default")
        }
    }
    
    func zoomToCurrentLocation() {
        guard let locationManager,
              let location = locationManager.location else { return }
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: viewModel.defaultLatitudinalMetersOnZoom,
                                        longitudinalMeters: viewModel.defaultLongitudinalMetersOnZoom)
        mapView.setRegion(region, animated: true)
    }
    
    func getAdressOfAnnotation(location: CLLocation, annotation: CustomAnnotation) -> CustomAnnotation {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {[weak self] (placemarks, error) in
            if error != nil { return }
            guard let placemark = placemarks?.first else { return }
            annotation.address = self?.viewModel.formatAddress(from: placemark)
        }
        return annotation
    }
    
    func startTracking() {
        currentSessionPoints = []
        viewModel.isTracking = true
    }
    
    func stopTracking() {
        previousLocation = nil
        viewModel.isTracking = false
        if !currentSessionPoints.isEmpty {
            userLocationPoints.append(contentsOf: currentSessionPoints)
        }
    }
}
