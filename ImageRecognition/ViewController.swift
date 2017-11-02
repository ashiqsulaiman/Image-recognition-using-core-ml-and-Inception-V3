//
//  ViewController.swift
//  ImageRecognition
//
//  Created by Ashiq Sulaiman on 26/10/17.
//  Copyright © 2017 Ashiq Sulaiman. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum //change to photolibrary to access photo album
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedImage
            imageView.contentMode = .scaleAspectFit
            //convert the UI image to CI image to get interpretation from coreml
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Converting image from UIImage to CIImage failed")
        }
            
        detect(image: ciimage)
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
}
    
    func detect(image: CIImage){
        // load the model using the imported inception v3 model
        //name of the model that is being used.
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML model failed")
        }
        
        //request the model to classify the data whatever we pass
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            
            if let firstResult = results.first{
//                if firstResult.identifier == "iphone" {
//                    self.navigationItem.title = "iphone"
//                } else {
//                    self.navigationItem.title = "iphone"
//                }
                self.navigationItem.title = firstResult.identifier
            }
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image) // image is the input parameter of the detect function
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}
