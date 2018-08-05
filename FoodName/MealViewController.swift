//
//  ViewController.swift
//  FoodName
//
//  Created by james king on 18/05/2018.
//  Copyright © 2018 james king. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingController: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        os_log("meal view loaded")
        nameTextField.delegate = self;
        if let meal = meal {
            navigationItem.title = meal.mName
            nameTextField.text = meal.mName
            photoImageView.image = meal.mImage
            ratingController.rating = meal.mRating
        }
    }
    
    private func checkText(){
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkText()
        navigationItem.title = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func imageViewTapGesture(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected dict of image selection, recieved \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Cancelling meal addition")
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingController.rating
        
        meal = Meal(inName: name, inImage: photo, inRating: rating)
        
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isBeingAdded = presentingViewController is UINavigationController
        if isBeingAdded{
            dismiss(animated: true, completion: nil)
        } else if let owningNavController = navigationController {
            owningNavController.popViewController(animated: true)
        } else {
            fatalError("View is controlled by a nav controller")
        }
    }
}

