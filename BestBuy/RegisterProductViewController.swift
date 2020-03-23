//
//  RegisterProductViewController.swift
//  BestBuy
//
//  Created by Jose Javier Aviles Gomez on 26/02/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit
import CoreData

class RegisterProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var ivProductImage: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    
    private var pickerStates = UIPickerView()
    
    var fetchedResultsController: NSFetchedResultsController<State>!
    
    var product: Product?
      
    override func viewDidLoad() {
        super.viewDidLoad()

        loadStates()
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
    
    private func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
                
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
 
    //Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fetchedResultsController.fetchedObjects?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let states = fetchedResultsController.fetchedObjects else { return }
        if(!states.isEmpty) {
            tfState.text = states[row].name
        }
    }
    
  
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
        
        
        if (validateFields()) {
            if (product == nil) {
                product = Product(context: context)
            }

            product?.name = tfProductName.text
            product?.image = ivProductImage.image
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "State")
            fetchRequest.predicate = NSPredicate(format: "name = %@", tfState.text!)
            
            do {
                let result = try? context.fetch(fetchRequest)
                product?.state = result?[0] as? State ?? nil
            }
            
            
            product?.usedCard = swCard.isOn
            product?.value = Double(tfValue.text!) ?? 0
            
            try? context.save()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func validateFields() -> Bool {
        
        var fieldsValidated = true
        
        if(tfProductName.text!.isEmpty) {
            showError(message: "O campo 'Nome do produto' é obrigatorio!")
            fieldsValidated = false
        }
        
        if (ivProductImage.image == nil) {
            showError(message: "O campo 'Imagem' é obrigatorio!")
            fieldsValidated = false
        }
        
        if(tfState.text!.isEmpty) {
            showError(message: "O campo 'Estado' é obrigatorio!")
            fieldsValidated = false
        }
        
        if(tfValue.text!.isEmpty) {
            showError(message: "O campo 'Valor' é obrigatorio!")
            fieldsValidated = false
        }
        
        //checar se o número é válido
        let valueDb = Double(tfValue.text!) ?? 0
                  
        if (valueDb == 0) {
            showError(message: "O campo 'Valor' é inválido!")
        }
        
        return fieldsValidated
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
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


extension RegisterProductViewController: NSFetchedResultsControllerDelegate {

    //Vai ser chamado quando for mudado alguma dado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        pickerStates.reloadAllComponents()
    }
    
}
