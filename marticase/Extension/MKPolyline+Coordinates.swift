//
//  MKPolyline+Coordinates.swift
//  marticase
//
//  Created by safa uslu on 16.05.2024.
//

import MapKit

extension MKPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coordinates = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: self.pointCount)
        self.getCoordinates(&coordinates, range: NSRange(location: 0, length: self.pointCount))
        return coordinates
    }
}
