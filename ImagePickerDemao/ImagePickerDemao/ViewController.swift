//
//  ViewController.swift
//  ImagePickerDemao
//
//  Created by Eric Lee on 2/18/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // ImagePickerController. A source (not set here) must be set first
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        // CoreLocation. Authorization must be requested first
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Begin retrieving location after verifying the app has authorization
        if CLLocationManager.locationServicesEnabled() {
            guard locationManager.authorizationStatus == .authorizedWhenInUse else {
                print("location manager does not have when in use authorization")
                return
            }
            
            locationManager.startUpdatingLocation()
        }
    }

    // openPhotoLibrary presents a view controller that allows user to select a photo from their
    // photo library
    @IBAction func openPhotoLibrary(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true) {
            print("Photo library has been presented")
        }
    }
    
    // openCamera presents a view controller that allows users to take a photo with the camera
    @IBAction func openCamera(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true) {
            print("Camera has been presented")
        }
    }
    
    // updateLocation verifies the location manager and then starts updating the location
    @IBAction func updateLocation(_ sender: Any) {
        guard CLLocationManager.locationServicesEnabled() else {
            print("location services are not enabled")
            return
        }
        
        guard locationManager.authorizationStatus == .authorizedWhenInUse else {
            print("location manager does not have authorization")
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    // imagePickerController is a delegate function that is called when the user finishes selecting
    // a picture from the UIImagePickerController source.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Retrieve the user's image. info[.originalImage] is of type `Any?` so cast it to UIImage
        guard let userImg = info[.originalImage] as? UIImage else {
            return
        }
        
        // Set the UIImageView image source. Functionality to upload image to Firebase Cloud
        // Storage should be placed here
        imageView.image = userImg
        imageView.contentMode = .scaleAspectFill
        
        dismiss(animated: true) {
            print("UIImagePickerController has been dismissed")
        }
    }
    
    // locationManagerDidChangeAuthorization is called whenever the location authorization for the
    // app has changed. This function should tell the app to make changes when location access is
    // denied
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("location manager authorization has changed!")
    }
    
    // locationManager is called every time the phone location is updated.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            print("failed to retrieve location after update")
            return
        }
        
        // Retrieve the latitude and longitude. Geohash for Firestore should also be handled here
        let coord = location.coordinate
        let latitude = coord.latitude
        let longitude = coord.longitude
        
        latitudeLabel.text = "Latitude: \(latitude)"
        longitudeLabel.text = "Latitude: \(longitude)"
        locationManager.stopUpdatingLocation()
    }
    
    
}

