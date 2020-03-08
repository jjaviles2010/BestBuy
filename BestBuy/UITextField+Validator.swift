//
//  UITextField+Validator.swift
//  BestBuy
//
//  Created by Jose Javier Aviles Gomez on 06/03/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit
import Foundation

extension UITextField {
    func validateInput(fieldDesc: String) {
        if (self.text?.isEmpty)
            showAlert
    }
    
     func showError() {
        let alert = UIAlertController(title: "Erro", message: "Você precisa preencher os valores com números corretos", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
