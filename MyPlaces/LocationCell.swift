//
//  LocationCell.swift
//  MyPlaces
//
//  Created by Aslan Arapbaev on 11/11/20.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }


    func configure(for location: Location) {
        if location.locationDescription.isEmpty == true {
            descriptionLabel.text = "NO DESCRIPTION"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        
        if let placemark = location.placemark {
            var text = ""
            
            if let house = placemark.subThoroughfare {
                text += house + " "
            }
            
            if let street = placemark.thoroughfare {
                text += street + ", "
            }
            
            if let city = placemark.locality {
                text += city + ", "
            }
            
            if let zip = placemark.postalCode {
                text += zip
            }
            
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
        }
    }

}
