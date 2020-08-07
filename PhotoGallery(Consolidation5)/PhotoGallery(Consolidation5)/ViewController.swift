//
//  ViewController.swift
//  PhotoGallery(Consolidation5)
//
//  Created by Emily Widjaja on 15/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//  Unable to connect phone to laptop, so it is not possible to test adding image functionality.
//  To add: Capability to save (UserDefaults), delete button, rename button.

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var images = [Image]()
    var imageNumber = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
    }

    //MARK: - Adding New Images Method
    @objc func addNewImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        } else {
            print("No Camera found!")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        let name = "Image Number \(imageNumber)"
        imageNumber += 1
        
        let imageInfo = Image(name: name, image: image)
        images.append(imageInfo)
        
    }
    
    //MARK: - Table View Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Image Preview", for: indexPath) as? ImageCell else {
            fatalError("Unable to dequeue ImageCell.")
        }
        let image = images[indexPath.row]
        cell.imagePreview.image = image.image
        cell.name.text = image.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Image") as? DetailViewController else {return}
        let image = images[indexPath.row]
        vc.imageView.image = image.image
        vc.title = image.name
        present(vc, animated: true)
    }
    
}

