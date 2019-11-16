//
//  MapView.swift
//  RandomUser
//
//  Created by Haoming Ma on 16/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    private let coordinate: CLLocationCoordinate2D

    init(lat: Double, lon: Double) {
        
        print("lat: \(lat), lon: \(lon)")
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 45.0, longitudeDelta: 45.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        view.addAnnotation(annotation)
        
        view.setRegion(region, animated: true)
    }
}
