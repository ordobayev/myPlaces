//
//  LocationDetailsTableViewController.swift
//  MyPlaces
//
//  Created by Aslan Arapbaev on 10/28/20.
//

import UIKit
import CoreLocation
import CoreData


private let dateFormatter: DateFormatter = { // lazy loading
    let formatter = DateFormatter()
    
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    
    print("--- formatter created ---")
    
    return formatter
}()

class LocationDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placeMark: CLPlacemark?
    var categoryName = "No Category"
    var currentDate = Date()
    var descriptionText = ""
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                self.descriptionText = location.locationDescription
                self.categoryName = location.category
                self.currentDate = location.date
                self.placeMark = location.placemark
                self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let locationToEdit = locationToEdit {
            title = "Edit Location"
        }

        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placeMark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = format(date: currentDate)
        
    }

    @IBAction func done(_ sender: UIBarButtonItem) {
        
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        // 1. -> creating Location and making changes
        
        let location: Location
        
        if let locationToEdit = locationToEdit {
            // edit
            hudView.text = "Updated"
            location = locationToEdit
        } else {
            // create
            hudView.text = "Saved"
            location = Location(context: managedObjectContext) // creating location
        }
        
        location.category = categoryName   // changing or editing
        location.locationDescription = descriptionTextView.text
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = currentDate
        location.placemark = placeMark // cant save nil placemark
        
        // 2. -> save() all changes
        
        do {
            try managedObjectContext.save()
            // success
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
            
        } catch {
            fatalCoreDataError(error)
        }
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerTVController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    func format(date: Date) -> String {
        print("calling formatter")
        return dateFormatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickCategory" {
            let destVC = segue.destination as! CategoryPickerTVController
            destVC.selectedCategoryName = categoryName
        }
    }
    
    func string(from placemark: CLPlacemark) -> String {
        
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
        
        if let state = placemark.administrativeArea {
            text += state + " "
        }
        
        if let zipCode = placemark.postalCode {
            text += zipCode + ", "
        }
        
        if let country = placemark.country {
            text += country
        }
        
        return text
    }
    
    // MARK: - Table View Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        } else {
            descriptionTextView.resignFirstResponder()
        }
    }
    
}


/*
 1. new Controller -> Category (TableView Controller) select category and show
 2. Done -> save -> CoreData
 3. CoreData -> DataModel -> Entity -> Attributes
 4. Entity -> class object subclass of NSManagedObject
 5. SceneDelegate -> persistentContainer (viewContext) -> Parent -> Child (managedObjectContext)
 6. managedObjectContext -> create location(NSManagedObject) make changes -> save all changes
 7. Liya -> open DataModel click go
 8. Extra -> HUD View
 */
