//
//  ProfileImageViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 05.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit


class ProfileImageViewController: UICollectionViewController {
    
    fileprivate let reuseIdentifier = "imageCell"
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var searches = [FlickrPhoto]()
    fileprivate let requestSender = RequestSender()
    
    var pickedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flickrSearch = FlickrSearchService(requestSender: requestSender)
        flickrSearch.flickrSearch { flickrPhoto, error in
            self.searches = flickrPhoto!
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! FlickrPhotoCell
        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        
        cell.backgroundColor = UIColor.white
        
        cell.imageView.image = flickrPhoto.thumbnail
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photoForIndexPath(indexPath: indexPath).thumbnail
        
        self.pickedImage = photo
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            
            if flickrPhoto.thumbnail == nil {
                
                guard let url = flickrPhoto.flickrImageURL(), let imageData = try? Data(contentsOf: url as URL) else {
                    print("no URL or Data")
                    return
                }
                
                if let image = UIImage(data: imageData) {
                    flickrPhoto.thumbnail = image
                }
                DispatchQueue.main.async {
                    collectionView.reloadItems(at: [indexPath])
                }
            }
        }
        
    }
    
    
}

private extension ProfileImageViewController {
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.row]
    }
}

extension ProfileImageViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
