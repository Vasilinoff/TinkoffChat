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
    
    var rootLayer:CALayer = CALayer()
    let emitter = CAEmitterLayer()
    var pointTap: CGPoint?
    

    
    var pickedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(longPressRecognizer)
        
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
    
    func longPressed(gesture: UITapGestureRecognizer)  {
        if gesture.state == .began {
            print("start")
            pointTap = gesture.location(in: gesture.view)
            DispatchQueue.main.async {
                self.createEmitter()
            }
        }
        
        if gesture.state == .changed {
            print("changed")
            DispatchQueue.main.async {
                self.pointTap = gesture.location(in: gesture.view)
                self.createEmitter()
            }
        }
        
        if gesture.state == .ended {
            print("ended")
            DispatchQueue.main.async {
                self.stopEmitter()
            }
        }
    }
    
    func createEmitter() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let cell = CAEmitterCell()
        emitter.frame = rect
        view.layer.addSublayer(emitter)
        
        emitter.emitterShape = kCAEmitterLayerCircle
        emitter.emitterPosition = pointTap!
        
        emitter.emitterSize = rect.size
        cell.contentsScale = 8
        cell.birthRate = 20
        cell.lifetime = 1
        cell.velocity = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 0.5
        cell.spinRange = 1.2
        cell.scaleRange = -0.05
        cell.contents = UIImage(named: "spark")?.cgImage
        
        emitter.emitterCells = [cell]
    }
    
    func stopEmitter() {
        emitter.removeFromSuperlayer()
    }
}

private extension ProfileImageViewController {
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.row]
    }
}

extension ProfileImageViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
