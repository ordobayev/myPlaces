//
//  Location+CoreDataClass.swift
//  MyPlaces
//
//  Created by Aslan Arapbaev on 11/4/20.
//
//

import Foundation
import CoreData
import MapKit

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var title: String? {
        return category
    }
    
    public var subtitle: String? {
        if locationDescription.isEmpty {
            return "NO DESCRIPTION"
        } else {
            return locationDescription
        }
    }

}
