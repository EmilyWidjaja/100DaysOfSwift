//
//  DetailViewController.swift
//  Project1
//
//  Created by Emily Widjaja on 2/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedPictureNumber: Int?
    var totalPictures: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picture \(selectedPictureNumber!) of \(totalPictures!)" //passing variables not working
        
        //navigationController?.navigationBar.prefersLargeTitles = false //this should not be used as it makes the main page title small as well
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            
        }
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }

    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)
            else {
            print("No image found.")
            return
        }
        
        
        let vc = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: []) //arrays show what is being shared when tapped
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem //needed for iPad, since bar not always shown. Defines what action is needed for it to appear/popover
        present(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
