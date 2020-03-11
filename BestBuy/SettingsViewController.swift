//
//  SettingsViewController.swift
//  BestBuy
//
//  Created by administrator on 3/10/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit

struct Keys {
    static let cotacao_dolar = "cotacao_dolar"
    static let iof = "iof"
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tfDollar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            
        view.addGestureRecognizer(tapGesture)
    }
      
    override func viewWillAppear(_ animated: Bool) {
        tfDollar.text = ud.string(forKey: Keys.cotacao_dolar)
        tfIOF.text = ud.string(forKey: Keys.iof)
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
        
        textField.resignFirstResponder()
        ud.set(textField.text, forKey: Keys.cotacao_dolar)
        print("aqui")
        return true
    }
}
