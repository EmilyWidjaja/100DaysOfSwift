//
//  ViewController.swift
//  Project1
//
//  Created by Emily Widjaja on 2/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
// Something wrong with layout... i'm not sure what. will debug at a later stage

import UIKit

class ViewController: UICollectionViewController {

    var pictures = [String]()
    var selectedPictureNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
        // Do any additional setup after loading the view.
        performSelector(inBackground: #selector(loadPictures), with: nil)
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default //built in filemanager. using to look for file.
        let path = Bundle.main.resourcePath! //sets path for images on bundle. bundle holds all assets.
        let items = try! fm.contentsOfDirectory(atPath: path) //set to directory found at path. so everything in the resource directory of app.
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                pictures = pictures.sorted()
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - CollectionView Layout
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureLabelCell else {
            fatalError("Unable to dequeue PictureLabelCell.")
        }
        cell.name.text = pictures[indexPath.item]
        cell.name.font = .systemFont(ofSize: 22.0)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                   vc.selectedImage = pictures[indexPath.item]
                   navigationController?.pushViewController(vc, animated: true)
                   
                   vc.selectedPictureNumber = indexPath.item + 1
                   vc.totalPictures = pictures.count
        }
    }
    
}

