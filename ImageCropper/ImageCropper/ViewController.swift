//
//  ViewController.swift
//  ImageCropper
//
//  Created by Hiren Bhadreshwara on 4/22/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func imageButtonTapped(_ sender: UIButton) {
        let photoImagePicker = self.imagePicker(sourceType: .photoLibrary)
        self.present(photoImagePicker, animated: true) {

        }
return
        let alertVC = UIAlertController(title: "Picker", message: "Library or Camera", preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let weakself = self else {
                return
            }

            let cameraImagePicker = weakself.imagePicker(sourceType: .camera)
            weakself.present(cameraImagePicker, animated: true) {
            }
        }

        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] (action) in
            guard let weakself = self else {
                return
            }

            let photoImagePicker = weakself.imagePicker(sourceType: .photoLibrary)
            weakself.present(photoImagePicker, animated: true) {

            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }


    private func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = sourceType
        return pickerController
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage]
        self.dismiss(animated: false, completion: {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ImageCropViewController") as! ImageCropViewController
            vc.selectedImage = info[.originalImage] as? UIImage
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}

