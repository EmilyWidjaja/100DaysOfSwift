//
//  DetailViewController.swift
//  FlagViewer (Consolidation 1)
//
//  Created by Emily Widjaja on 7/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageLoaded: UIImageView!
    
    var imageToShow: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //formats titling
        title = "Flag of \(imageToShow!.uppercased())"
        navigationItem.largeTitleDisplayMode = .never
        
        //shows appropriate image
        if imageToShow != nil {
            imageLoaded.image = UIImage(named: imageToShow!)
        }
        else {
            print("There's nothing!")
        }
        
        //navigation bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        // Do any additional setup after loading the view.
    }
    
    @objc func shareTapped() {
        let image = imageLoaded.image?.jpegData(compressionQuality: 0.8)
        let name = imageToShow!
        
        let activityVC = UIActivityViewController(activityItems: [image, name], applicationActivities: [])
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true)
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
