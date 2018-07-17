/*
See LICENSE folder for this sample’s licensing information.

Abstract:
View controller for selecting images and applying Vision + Core ML processing.
*/

import UIKit
import CoreML
import Vision
import ImageIO

class ImageClassificationViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Image Classification
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: ProductClassifier().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        stopSpinner()
    }
    
    func stopSpinner() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func startSpinner() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        self.startSpinner()
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
                self.stopSpinner()
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                self.stopSpinner()
                return
            }
            
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                print("Nothing recognized.")
                self.stopSpinner()
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                
                print("Classification:\n" + descriptions.joined(separator: "\n"))
                self.stopSpinner()
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let resultsTableViewController = storyBoard.instantiateViewController(withIdentifier: "ResultsTableViewController") as! ResultsTableViewController
                
          //      resultsTableViewController.results = descriptions
                self.navigationController?.pushViewController(resultsTableViewController, animated: true)
            }
        }
    }
    
    // MARK: - Photo Actions
    
    @IBAction func takePicture() {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.startSpinner()
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.startSpinner()
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        photoSourcePicker.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        photoSourcePicker.popoverPresentationController?.sourceView = self.view
        photoSourcePicker.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        photoSourcePicker.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        present(photoSourcePicker, animated: true, completion: nil)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        
        present(picker, animated: true)
    }
}

extension ImageClassificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        updateClassifications(for: image)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.stopSpinner()
        dismiss(animated: true, completion: nil)
    }
}
