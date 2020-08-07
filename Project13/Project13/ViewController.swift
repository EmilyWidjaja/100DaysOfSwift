//
//  ViewController.swift
//  Project13
//
//  Created by Emily Widjaja on 16/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
// Come back to this challenge. Can do them separately but not together.

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    var currentImage: UIImage!
    var unfinishedEditingImage: UIImage!
    @IBOutlet var changeFilterLabel: UIButton!
    @IBOutlet var changeSecondFilterLabel: UIButton!
    @IBOutlet var secondIntensity: UISlider!
    
    
    var context: CIContext!         //handles rendering (computationally expensive to make an instance)
    var currentFilter: CIFilter!    //stores whatever filter the user has activated
    var currentSecondFilter: CIFilter!
    var filter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "InstaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        let initialFilter = "CISepiaTone"
        currentFilter = CIFilter(name: initialFilter)           //filter will apply sepia tone
        changeFilterLabel.setTitle(initialFilter, for: .normal)
        
        let initialSecondFilter = "CIVignette"
        currentSecondFilter = CIFilter(name: initialSecondFilter)
        changeSecondFilterLabel.setTitle(initialSecondFilter, for: .normal)
    }
    
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        currentImage = image
        
        //lets users drag slider to change the amount on the filter
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)    //sets current filter's input image (forKey says what the inputted value is)
        applyProcessing(slider: 1)       //called when image first imported
        currentSecondFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing(slider: 2)
    }

    //applies actual image processing
    func applyProcessing(slider: Int) {
        if slider == 1 {
            filter = currentFilter
        } else if slider == 2 {
            filter = currentSecondFilter
        }
        let inputKeys = filter.inputKeys         //reads all inputKeys (filters may use different keys)
        
        if inputKeys.contains(kCIInputIntensityKey) {
            filter.setValue(intensity.value, forKey: kCIInputIntensityKey)   //passes in value of slider as intensity for current filter. read end image as a UIImage that can be shown on the screen. CIImage -> UIImage not easily possible directly. So CIImage -> CGImage -> UIImage.
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            filter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)    //radius goes from more than 0 to 1 (slider between 0-1)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            filter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            filter.setValue(CIVector(x: currentImage.size.width/2, y: currentImage.size.height/2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = filter.outputImage else {return}
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {//from: size of image. This step is where the image starts to be buil
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
            currentImage = processedImage
        }
    }
    
    //checks whether it saved to library successfully
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //MARK: - Button & Slider Methods
    
    //shows UIAlertController with filter options
  /*  @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)  //actionSheet style requires popover in iPad
        
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender       //the sender (UIButton) is the source for the popover
            popoverController.sourceRect = sender.bounds             //dimensions of popover
        }
        present(ac, animated: true)
    }
    #todo:setFilters
    func setFilter(action:UIAlertAction) {
        guard currentImage != nil else {return}
        
        //creates new CIFilter
        guard let actionTitle = action.title else {return}
        currentFilter = CIFilter(name: actionTitle)
        changeFilterLabel.setTitle(actionTitle, for: .normal)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    } */
    
    @IBAction func save(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            let ac = UIAlertController(title: "No Image Found", message: "There is no image to save.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing(slider: 1)
    }
    
    @IBAction func secondIntensityChanged(_ sender: Any) {
        applyProcessing(slider: 2)
    }
    
    
    
    

}

