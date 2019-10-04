//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/09/30.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController{
    let viewModel = ViewModel.shared
    var fetchedResultsController : NSFetchedResultsController<Pin>!
    var dataModel :DataController!
    var deletingPins : Bool = false
   
    @IBOutlet weak var deletingView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        _ = getAllPins()
        let dropPinLongPress = UILongPressGestureRecognizer()
        dropPinLongPress.addTarget(self, action: #selector(dropPin))
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = editButtonItem
        mapView.addGestureRecognizer(dropPinLongPress)
        addAnnotations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        fetchedResultsController = nil
    }
    func addAnnotations(){
    
        var annotations = [MKPointAnnotation]()
    
        for location in viewModel.pins {
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: location.latitute, longitude:  location.longitude)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
    }
    
    @objc func dropPin(_ sender: UILongPressGestureRecognizer){
        guard sender.state != UIGestureRecognizer.State.began else{
            return
        }
        
        // Get location of long presss
        let location = sender.location(in: mapView)
        let currentCoordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Generete pin
        let currentPin = MKPointAnnotation()
        currentPin.coordinate = currentCoordinate
        // Add pin to annotation
        mapView.addAnnotation(currentPin)
        // Save pin
        self.saveLocations(lat: currentPin.coordinate.latitude, long: currentPin.coordinate.longitude)
    }
    
    func openPhotoLibrary(){
        let controller = PhotoLibraryViewController.init(nibName: "PhotoLibraryViewController", bundle: nil)
        controller.dataModel = dataModel
        self.present(controller, animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)

        guard let annotation = view.annotation else{
            return
        }
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            for pin in fetchedObjects {
                if pin.latitute == annotation.coordinate.latitude && pin.longitude == annotation.coordinate.longitude {
                    // If editing state is true, tapping pins should removed them
                    if deletingPins {
                        dataModel.viewContext.delete(pin)
                        try? dataModel.viewContext.save()
                        mapView.removeAnnotation(annotation)
                    } else {
                        self.viewModel.currentPin = pin
                        self.viewModel.annotation = annotation.coordinate
                        self.openPhotoLibrary()
                    }
                }
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        deletingPins = !deletingPins
        if editing {
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.view.frame.origin.y -= self.deletingView.frame.height
                self.deletingView.isHidden = false
            })
        } else {
            UIView.animate(withDuration: 0.5) {
                self.view.frame.origin.y += self.deletingView.frame.height
                self.deletingView.isHidden = true
            }
        }
    }
}

extension MapViewController: NSFetchedResultsControllerDelegate {
    
    // Save pin location
    func saveLocations(lat: CLLocationDegrees, long: CLLocationDegrees){
        do{
            self.viewModel.currentPin = Pin(context: dataModel.persistentContainer.viewContext)
            self.viewModel.currentPin.latitute  = lat
            self.viewModel.currentPin.longitude  = long
            self.viewModel.currentPin.createdDate = Date() as NSDate
            try dataModel.persistentContainer.viewContext.save()
            self.viewModel.pins.append(self.viewModel.currentPin)
            
        } catch let error {
            print(error)
        }
    }
    
    // Fetch pins from core data
    
    func getAllPins() -> [Pin]? {
        
        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataModel.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            fatalError("Fetching the Pins could not be performed \(error.localizedDescription)")
        }
        
        do {
            let totalPins = try fetchedResultsController.managedObjectContext.count(for: fetchRequest)
            for i in 0..<totalPins {
                self.viewModel.pins.append(fetchedResultsController.object(at: IndexPath(row: i, section: 0)))
            }
            return self.viewModel.pins
        } catch {
            return nil
        }
    }
}
