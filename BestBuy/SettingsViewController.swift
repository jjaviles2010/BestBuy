//
//  SettingsViewController.swift
//  BestBuy
//
//  Created by administrator on 3/10/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: UIViewController {

    @IBOutlet weak var tfDollar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
