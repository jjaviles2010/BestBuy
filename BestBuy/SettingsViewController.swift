//
//  SettingsViewController.swift
//  BestBuy
//
//  Created by administrator on 3/10/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var tfDollar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var stateTableView: UITableView!
    
    let userDefault = UserDefaults.standard
    var state: [NSManagedObject] = []
    
    var fetchedResultsController: NSFetchedResultsController<State>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadStates()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            
        view.addGestureRecognizer(tapGesture)
        stateTableView.delegate = self
        
    }
      
    override func viewWillAppear(_ animated: Bool) {
        tfDollar.text = userDefault.string(forKey: "cotacaoDolar")
        tfIOF.text = userDefault.string(forKey: "iof")
    }
    	
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func loadStates() {
        
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func save(stateName: String, tax: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
            
      let entity =
        NSEntityDescription.entity(forEntityName: "State",
                                   in: managedContext)!
      
      let stateLocal = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
            
      stateLocal.setValue(stateName, forKeyPath: "name")
      stateLocal.setValue(Double(tax), forKeyPath: "tax")
      
      do {
        try managedContext.save()
        state.append(stateLocal)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }

    
    @IBAction func btAddState(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Adicionar Estado",
                                      message: "Adicionar um novo estado",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Adicionar",
                                       style: .default) {
           [unowned self] action in
                                        
           guard let textFieldState = alert.textFields?.first,
            let stateToSave = textFieldState.text else {
              return
          }
          
        guard let textFieldTax = alert.textFields?[1],
            let taxToSave = textFieldTax.text else {
                return
          }
                                        
          self.save(stateName: stateToSave, tax: taxToSave)
          self.stateTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do Estado"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Imposto (%)"
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveUserDefaultFromTextField(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveUserDefaultFromTextField(textField)
    }
    
    func saveUserDefaultFromTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        switch textField {
        case tfDollar:
            userDefault.set(textField.text, forKey: "cotacaoDolar")
        case tfIOF:
            userDefault.set(textField.text, forKey: "iof")
        default:
            break
        }

    }
    
}

extension SettingsViewController: NSFetchedResultsControllerDelegate {

    //Vai ser chamado quando for mudado alguma dado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        stateTableView.reloadData()
        
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections")
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRows")
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as! SettingsStateTableViewCell

        let state = fetchedResultsController.object(at: indexPath)
        
        cell.prepare(with: state)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let state = fetchedResultsController.object(at: indexPath)
            context.delete(state)
            try? context.save()
        }
    }
      
}
