//
//  ViewController.swift
//  Project10
//
//  Created by Emily Widjaja on 14/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {  //conforms to both protocols
    var people = [Person]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        
        //reads from disk
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true     //users can edit
        picker.delegate = self      //we can respond to messages from the picker
        present(picker, animated:  true)
    }
    
    var image: UIImage?
    //untested code for using camera to supply image. No opportunity to test.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
        guard let image = info[.editedImage] as? UIImage else {return}  //attempts to find image
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)      //reads doc Directory, and append the path to the image
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)  //write to disk. unlikely to fail, so no catch
        }
 */
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            picker.sourceType = .camera
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        } else {
            image = info[.editedImage] as? UIImage  //attempts to find image
            }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)      //reads doc Directory, and append the path to the image
        
        if let jpegData = image!.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)  //write to disk. unlikely to fail, so no catch
            let person = Person(name: "Unknown", image: imageName)
            people.append(person)
            save()
        }
        
        collectionView.reloadData()
        dismiss(animated: true) //dismisses imagepicker
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]     //.userDomainMask - want for current user
    }


    
    //MARK: - collectionView layout
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.") //type cast necessary as cell is of type UICollectionViewCell. So, needs guard let and fatalError will cause the program to terminate w/ error mssg
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor        //grey
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3   //rounds corners slightly
        cell.layer.cornerRadius = 7
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Edit Person", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self] _ in
            let acRename = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            acRename.addTextField()
            
            acRename.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self, weak acRename] _ in
                guard let newName = acRename?.textFields?[0].text else {return}
                person.name = newName
                self?.save()    //TODO: need to add to delete
                self?.collectionView.reloadData()
            })
            acRename.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(acRename, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Delete", style: .default) {
            [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
    
    
    
}

