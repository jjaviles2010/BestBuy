//
//  SettingsStateTableViewCell.swift
//  BestBuy
//
//  Created by user166354 on 3/12/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit

class SettingsStateTableViewCell: UITableViewCell {

    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbTax: UILabel!
        
    func prepare(with state: State) {
        lbState.text = state.name
        lbTax.text = String(state.tax)
    }

}
