//
//  ViewController.swift
//  Project1
//
//  Created by Emily Widjaja on 2/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

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
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 22.0) //= [cell.textLabel.font fontWithSize: 19.0]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
        }
    }
    
}

