//
//  DetailItemViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 10/25/18.
//  Copyright © 2018 myw. All rights reserved.
//


import UIKit
import CoreData
import Foundation
import Photos
import ChameleonFramework



class DetailItemViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var txfItemTitle: UITextField!
    @IBOutlet weak var cView: UICollectionView!
    @IBOutlet weak var textviewLabel: UILabel!
    @IBOutlet weak var collectionviewLabel: UILabel!
    //var item : Item!
    var notes = ""
    var photos = [Photo]()
    
    let vc = UIImagePickerController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var item :Item? {
        didSet{
            loadItems()
        }
    }
    
    
    @IBAction func btnCamera(_ sender: Any) {
        if checkPermission() {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                vc.delegate = self
                vc.allowsEditing = false
                
                // Create the subMenu controller (using alertViewController)
                let alertController = UIAlertController(
                    title: "Pick an image",
                    message: "Choose your image location",
                    preferredStyle: .alert)
                
                // Create the photo selection related actions
                if isPhotoLibrarayAvailable() {
                    let photoLibAction = UIAlertAction(title: "From Photos", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        self.vc.sourceType = .photoLibrary
                        self.present(self.vc, animated: true, completion: nil)
                       // self.loadImagePickerSource()
                    }
                    alertController.addAction(photoLibAction)
                }
                
                if isSavedPhotosAlbumAvailable() {
                    let photoAlbumAction = UIAlertAction(title: "From Album", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        self.vc.sourceType = .savedPhotosAlbum
                        self.present(self.vc, animated: true, completion: nil)
                    }
                    alertController.addAction(photoAlbumAction)
                }
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in return
                })
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure Collection View
        cView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cView.backgroundColor = UIColor.lightGray
        cView.alwaysBounceVertical = true
        cView.backgroundColor = UIColor.flatPowderBlue.lighten(byPercentage: 0.25)

        //Tool bar on top of Keyboard
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector(("doneButtonAction")))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()

        //Configure Title Text
        txfItemTitle.text = item?.title
        txfItemTitle.backgroundColor = UIColor.flatWhiteDark
        txfItemTitle.textColor = UIColor.flatNavyBlue
        txfItemTitle.inputAccessoryView = toolbar
        
        //Configure Notes (Text and Label) & Photo Label
        textView.text = item?.notes
        textView.keyboardDismissMode = .interactive
        textviewLabel.backgroundColor = UIColor.flatBlueDark
        textviewLabel.textColor = ContrastColorOf(textviewLabel.backgroundColor as! UIColor, returnFlat: true)
        textView.backgroundColor = UIColor.flatWhiteDark.lighten(byPercentage: 0.25)
        textView.inputAccessoryView = toolbar
        collectionviewLabel.backgroundColor = UIColor.flatBlueDark
        collectionviewLabel.textColor = ContrastColorOf(collectionviewLabel.backgroundColor as! UIColor, returnFlat: true)

        //Configure View
        self.navigationController?.isToolbarHidden = false
        self.title = "Edit Item"
    }
    
    
    //Done Button Action
    @objc func doneButtonAction() {
        self.view.endEditing(true)
        item?.title = txfItemTitle.text
        item?.notes = textView.text
        //self.title = item?.title
        saveItem()
    }
    
    //Save Current Context
    func saveItem() {
        do {
            try context.save()
            print("Item Saved")
        } catch {
            print("error encoding data: \(error)")
        }
    }
    
    //Check Capabilities and Permissions
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    func isPhotoLibrarayAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    func isSavedPhotosAlbumAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
    }
}

//Collection View Implementations
private extension DetailItemViewController {
    func photoForIndexPath(indexPath: IndexPath) -> Photo {
        return photos[(indexPath as IndexPath).row]
    }
    
    // Mark: - loadItems
    func loadItems(with request : NSFetchRequest<Photo> = Photo.fetchRequest(), predicate: NSPredicate? = nil){
        print("Loading Data in Local Array")
        let itemPredicate = NSPredicate(format: "parentItem IN %@", [item!])
        request.predicate = itemPredicate
        
        do {
            photos = try context.fetch(request)
        } catch {
            print("There is an error in fetchin request\(error)")
        }

        print("Number of Photos Fetched : \(photos.count)")
    }
}

//Implement PhotoPicker Function
extension DetailItemViewController: UIImagePickerControllerDelegate   {
    
    func checkPermission() -> Bool {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        var auth : Bool = false
        
        switch photoAuthorizationStatus {
            case .authorized:
                print("Access is granted by user")
                return true
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in print("status is \(newStatus)")
                    if newStatus == PHAuthorizationStatus.authorized {
                        print("success")
                        auth = true
                    }
                })
                return auth
            case .restricted:
                print("User do not have access to photo album.")
                return false
            case .denied:
                print("User has denied the permission.")
                return false
        }
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {self.dismiss(animated: true, completion: nil)
        print("It is cancelled.....:")
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //Inner Functions for Image Prep
        func prepareImageForSaving(image: UIImage) {
            
            // use date as unique id
            let date : Double = NSDate().timeIntervalSince1970
            
            // dispatch with gcd.
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                
                // create NSData from UIImage
                guard let imageData = UIImageJPEGRepresentation(image, 1) else {
                    // handle failed conversion
                    print("jpg error")
                    return
                }
                
                // scale image, I chose the size of the VC because it is easy
                let thumbnail = image
                
                guard let thumbnailData  = UIImageJPEGRepresentation(thumbnail, 0.7) else {
                    // handle failed conversion
                    print("jpg error")
                    return
                }
                
                saveImage(imageData: imageData as NSData, thumbnailData: thumbnailData as NSData, date: date)
                
            }
        }
        
        //Inner Functions for Saving Image
        func saveImage(imageData:NSData, thumbnailData:NSData, date: Double) {
            print("Saving New Image....")
            //set image data of fullres
            let newPhoto = Photo(context: self.context)
            
            //self.item?.photos
            newPhoto.image = imageData as Data
            newPhoto.parentItem = self.item
            
            let newThumbnail = Thumbnail(context: self.context)
            newThumbnail.image = thumbnailData as Data
            newThumbnail.photo = newPhoto
            
            do {
                try self.context.save()
                print("Image Saved......Loading Item")
                self.loadItems()
                print("Image Load Completed....Reloading cView")
                self.cView.reloadData()
            } catch {
                print("error encoding data: \(error)")
            }
        }
       
        print("The image is selecting....")
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage? else {
            print("No image found")
            return
        }
        
        //Save Selected Image to App Local Storage
        // send to save function
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)){
            print("Saving Image in main thread......")
            prepareImageForSaving(image: chosenImage)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// Mark - collectionView datasource and delegate method
extension DetailItemViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! DetailCollectionCell
       
        let cellImage = photoForIndexPath(indexPath: indexPath)
        if let validImage = UIImage(data: (cellImage.thumbs?.image)!) {
            cell.imageView.image = validImage
        } else {
            print(cellImage.thumbs?.id)
        }
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Photos in Collection: \(photos.count)")
        return photos.count
    }
}

// MarK: CollectionViewDataSource
extension DetailItemViewController {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)
         let controller = storyboard?.instantiateViewController(withIdentifier: "DetailImageViewController") as! DetailImageViewController
        controller.photo = photos[indexPath.row]
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let photo = photos[indexPath.row]
        self.context.delete(photo)
        photos.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        saveItem()
        
    }
}
