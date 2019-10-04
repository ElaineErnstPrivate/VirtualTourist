//
//  PhotoLibraryViewController.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/10/01.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class PhotoLibraryViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayOut: UICollectionViewFlowLayout!
    let viewModel = ViewModel.shared
    var dataModel: DataController!
    var fetchResultsController : NSFetchedResultsController<Photo>!
    var containsPhotos : Bool = false
    
    @IBOutlet weak var noPhotoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.noPhotoLabel.isHidden = true
        initializeCollectionView()
        getAllPhotos()
        setupMapView()
        setupPhotoCollection()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchResultsController = nil

    }
    func setupPhotoCollection(){
        if !containsPhotos{
            self.viewModel.getPhotos(handler: { (photos, error) in
                if let error = error{
                    print("Error:", error.localizedDescription)
                }
                else{
                    guard let photos = self.viewModel.photosFromFlickr else{
                        return
                    }
                    if photos.photos.photo.count > 0{
                        self.noPhotoLabel.isHidden = true
                        self.savePhotos(photos)
                    }else{
                        self.noPhotoLabel.isHidden = false
                    }
                }
            })
        }else {
           self.refresh()
        }
    }
    func initializeCollectionView(){
        collectionView.register(UINib(nibName:"PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"PhotoCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
     
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayOut.minimumInteritemSpacing = space
        flowLayOut.minimumLineSpacing = space
        flowLayOut.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func setupMapView(){
        let annotation = MKPointAnnotation()
        
         let coordinate = self.viewModel.annotation
        annotation.coordinate = coordinate
        
    
        self.mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
   
    func refresh(){
        DispatchQueue.main.async {
            if let indexPath = self.collectionView.indexPathsForSelectedItems {
                self.collectionView.reloadItems(at: indexPath)
            }
            
        }
        
    }
    @IBAction func backButtonPresses(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func deletePhotos(){
        containsPhotos = false
        let photos = fetchResultsController.fetchedObjects
        if let photos = photos {
            for photo in photos {
                dataModel.viewContext.delete(photo)
                try? dataModel.viewContext.save()
            }
        }
    }
    @IBAction func createNewCollection(_ sender: Any) {
        self.deletePhotos()
        let page = Int.random(in: 0..<12)
        self.viewModel.getPhotos(page:page, handler: { (photos, error) in
            if let error = error{
                print("Error:", error.localizedDescription)
            }
            else{
                guard let photos = self.viewModel.photosFromFlickr else{
                    return
                }
                if photos.photos.photo.count > 0{
                    self.noPhotoLabel.isHidden = true
                    self.savePhotos(photos)
                }else{
                    self.noPhotoLabel.isHidden = false
                }
                self.collectionView.reloadData()
            }
        })
    }
}

extension PhotoLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell

        let photo = fetchResultsController.object(at: indexPath)
        if photo.imageData == nil{
            guard let urlString = photo.url, let url = URL(string: urlString) else{
                return UICollectionViewCell()
            }
            cell?.activityIndicator.startAnimating()
            self.viewModel.downloadImages(photoUrl: url) { (photoData, error) in
                guard let data = photoData as NSData? else{
                    print("Fails to assign data")
                    return

                }
                photo.imageData = data
                // save data to photo object
                try? self.dataModel.viewContext.save()
                
                guard let imageData = photo.imageData as Data?,  let image = UIImage(data: imageData) else{
                    print("image failed")
                    return
                }
                DispatchQueue.main.async {
                    cell?.activityIndicator.stopAnimating()
                    cell?.configureCell(image: image)
                }
            }
        }
        else{
            guard let imageData = photo.imageData as Data?,  let image = UIImage(data: imageData) else{
                print("image failed")
                return UICollectionViewCell()
            }
            cell?.configureCell(image: image)
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoToDelete = fetchResultsController.object(at: indexPath)
        dataModel.viewContext.delete(photoToDelete)
        try? dataModel.viewContext.save()
    }

}

extension PhotoLibraryViewController: MKMapViewDelegate{
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
}

extension PhotoLibraryViewController: NSFetchedResultsControllerDelegate{
    // Save and download photo data
    func savePhotos(_ photos : PhotoResponse){
        
        let photoArray = photos.photos.photo
        
        for photo in photoArray{
        
            let currentPhoto = Photo(context: dataModel.viewContext)
            currentPhoto.pin = viewModel.currentPin
            currentPhoto.url = photo.photoURL().absoluteString
            try? dataModel.viewContext.save()
           
        }
    }
    // Load photos
    func getAllPhotos() {
        // set up fetched results controller
        let fetchRequest : NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin = %@", argumentArray: [self.viewModel.currentPin])
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataModel.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
        } catch  let error {
            print("Error:",error.localizedDescription)
        }
        do {
            let photoCount = try fetchResultsController.managedObjectContext.count(for: fetchRequest)
            
            if photoCount > 0 {
                containsPhotos = true
            } else {
                containsPhotos = false
            }
            
        } catch let error {
            print("Error:",error.localizedDescription)
        }
        
    }
    // Update objects
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        case .update:
            collectionView.reloadItems(at: [newIndexPath!])
        default:
            break
        }
    }
}
