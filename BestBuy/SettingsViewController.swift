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
    
    let userDefault = UserDefaults.standard
    var fetchedResultsController: NSFetchedResultsController<State>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadStates()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            
        view.addGestureRecognizer(tapGesture)
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

    @IBAction func btAddState(_ sender: UIButton) {
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
        
        //tableView.reloadData()
        
    }
    
}

//extension SettingsViewController: UITableViewDataSource {
    
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as! SettingsStateTableViewCell

        let state = fetchedResultsController.object(at: indexPath)
        
        cell.prepare(with: state)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedResultsController.object(at: indexPath)
            context.delete(product)
            try? context.save()
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
 */
    
//}
