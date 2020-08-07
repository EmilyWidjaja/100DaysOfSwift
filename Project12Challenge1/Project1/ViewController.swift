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
    var opened = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //read from disk - could do in background?
        let defaults = UserDefaults.standard
        if let savedOpenings = defaults.object(forKey: "opened") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                opened = try jsonDecoder.decode([String: Int].self, from: savedOpenings)
            } catch {
                print("Failed to load openings.")
            }
        }
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
            
            let pictureSelected = pictures[indexPath.row]
             if opened[pictureSelected] != nil {
                opened[pictureSelected]! += 1
            } else {
                opened[pictureSelected] = 1
            }
            save()
            print("Picture \(pictureSelected) has been opened \(opened[pictureSelected]!) times")
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(opened) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "opened")
        } else {
            print("Failed to save opening")
        }
    }
    
    
}

