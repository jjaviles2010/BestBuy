//
//  RegisterProductViewController.swift
//  BestBuy
//
//  Created by Jose Javier Aviles Gomez on 26/02/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit

class RegisterProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var ivProductImage: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    
    private var pickerStates = UIPickerView()
    
    var product: Product?
    var pickerData = [["Florida", "California", "Georgia", "Texas", "Washington"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateProductDetails()
        
        // Do any additional setup after loading the view.
        self.pickerStates.delegate = self
        self.pickerStates.dataSource = self
        tfState.inputView = pickerStates
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func populateProductDetails() {
        if let product = product {
            tfProductName.text = product.name
            ivProductImage.image = product.img
            tfState.text = product.state?.name
            tfValue.text = "\(product.value)"
            swCard.isOn = product.usedCard
        }
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
 
    //Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfState.text = pickerData[component][row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func selectProductImage(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde deseja escolher a imagem?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de foto", style: .default) { (_) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default) { (_) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        
        alert.addAction(photosAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.selectPicture(sourceType: .camera)
            }
            
            alert.addAction(cameraAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registerProduct(_ sender: Any) {
        
        let state: State
        if (product == nil) {
            product = Product(context: context)
        }
        product?.name = tfProductName.text
        product?.image = ivProductImage.image
        state = State(context: context)
        state.name = tfState.text
        state.tax = 2.2
        product?.state = state
        product?.usedCard = swCard.isOn
        product?.value = Double(tfValue.text!) ?? 0
        
        try? context.save()
        navigationController?.popViewController(animated: true)
        
    }
}


extension RegisterProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            let aspectRatio = image.size.width / image.size.height
            let maxSize: CGFloat = 500
            var smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: maxSize, height: maxSize/aspectRatio)
            } else {
                smallSize = CGSize(width: maxSize*aspectRatio, height: maxSize)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            ivProductImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
}
