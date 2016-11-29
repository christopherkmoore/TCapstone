//
//  AirbnbPicturesViewController.swift
//  Go
//
//  Created by modelf on 11/25/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class AirbnbPicturesViewController : UIViewController {
    
    var currentListing: AirbnbListing!
    var cache = NSCache<AnyObject, AnyObject>()
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedAirbnbPhotos: NSFetchedResultsController<AirbnbPhotos> = {
        let fetch = NSFetchRequest<AirbnbPhotos>(entityName: "AirbnbPhotos")
        fetch.predicate = NSPredicate(format: "airbnbListing == %@", self.currentListing)
        fetch.sortDescriptors = []
        
        let results = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        return results
    }()
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedAirbnbPhotos.performFetch()
        } catch {
            print("error performing fetch")
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        print(currentListing)
        
    }
    func reCreateURLS(_ bnbListing: AirbnbListing) {
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = floor(self.collectionView.frame.size.width/3)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
    }
    
    let darkGrayPlaceholderImage: UIImage = {
        var rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 500.0, height: 500.0)
        UIGraphicsBeginImageContext(rect.size)
        var context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor.darkGray.cgColor)
        context.fill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
        
    }()
}

extension AirbnbPicturesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("delegate method for number of items firing")
        return Int(currentListing.picture_count)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = fetchedAirbnbPhotos.object(at: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AirbnbCollectionViewCell", for: indexPath) as! AirbnbCollectionViewCell
        
        cell.imageView.image = darkGrayPlaceholderImage
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        
        func getImages(_ imageURL: String?) {
            DispatchQueue.global(qos: .userInitiated).async { () -> Void in
                if let url = imageURL {
                    if let newURL = URL(string: url),
                        let imageData = try? Data(contentsOf: newURL),
                        let image = UIImage(data: imageData) {
                        DispatchQueue.main.async(execute: { () -> Void in
                            //                                handler(img)
                            cell.imageView.image = image
                            cell.activityIndicator.stopAnimating()
                            cell.activityIndicator.isHidden = true
                            self.cache.setObject(image, forKey: indexPath.row as AnyObject)
                        })
                    }
                }
            }
        }

        if self.cache.object(forKey: indexPath.row as AnyObject) != nil {
            cell.imageView.image = (self.cache.object(forKey: indexPath.row as AnyObject) as! UIImage)
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        } else {
            getImages(photo.photo)
        }
        
        print("delegate for cell printing")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
    
}
