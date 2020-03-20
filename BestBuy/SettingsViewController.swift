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
    
    func save(stateName: String, tax: String) {
        
        let entity =
            NSEntityDescription.entity(forEntityName: "State",
                                       in: context)!
        
        let state = NSManagedObject(entity: entity,
                                    insertInto: context)
        
        state.setValue(stateName, forKeyPath: "name")
        state.setValue(Double(tax), forKeyPath: "tax")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /*
     // MARK: - Actions
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func btAddState(_ sender: UIButton) {
        showAlertState()
    }
    
    private func showAlertState(editing: Bool = false) {
        
        let alert = UIAlertController(title: !editing ? "Adicionar " : "Alterar " + "estado",
                                      message: !editing ? "Adicionar um novo " : "Alterar o " + "estado",
                                      preferredStyle: .alert)
              
        
        let saveAction = UIAlertAction(title: !editing ? "Adicionar" : "Alterar",
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
                                        
                                        if (!self.validateFields(state: stateToSave, tax: taxToSave)) {
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
    private func validateFields(state: String, tax: String) -> Bool {
                
        var errorMessages: [String] = []
        
        if (state.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            errorMessages.append("O campo 'Nome do estado' é obrigatório.")
        } else {
            //checar se já existe
            var errorStateMessage = ""
            if (isStateExists(stateName: state, errorMessage: &errorStateMessage)) {
                errorMessages.append(errorStateMessage)
            }
        }
        
        if (tax.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            errorMessages.append("O campo 'Taxa' é obrigatório.")
        } else {
            //checar se o número é válido
            let taxDb = Double(tax) ?? 0
            
            if (taxDb == 0 || taxDb >= 100) {
                errorMessages.append("O campo 'Taxa' é inválido [Valores válidos entre 0 e 99.9].")
            }
        }
        
        if (errorMessages.count > 0) {
            showError(errorMessages: errorMessages)
            return false
        } else {
            return true
        }

    }
    
    private func isStateExists(stateName: String, errorMessage: inout String) -> Bool {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
                
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", stateName)
        
        do {
            let states = try context.fetch(fetchRequest)
            if (states.count > 0) {
                errorMessage = "Estado já cadastrado."
                return true
            }
        } catch _ as NSError {
            errorMessage = "Erro interno. Tente novamente."
            return true
        }
        return false
    }
    
    private func showError(errorMessages: [String]) {
        let alert = UIAlertController(title: "Erro", message: errorMessages.joined(separator: "\n"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (fetchedResultsController.fetchedObjects?.count == 0) {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "Nenhum estado cadastrado!"
            emptyLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            tableView.backgroundView = nil
            return fetchedResultsController.fetchedObjects?.count ?? 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    /*private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as! SettingsStateTableViewCell
        let state = fetchedResultsController.object(at: indexPath)
        print("State editing ")
        return cell
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let selectedTrail = trails[indexPath.row]
        print("Linha selecionada \(indexPath.row)")
        
    }
    
}
