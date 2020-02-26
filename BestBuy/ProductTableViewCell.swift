//
//  ProductTableViewCell.swift
//  BestBuy
//
//  Created by Jose Javier Aviles Gomez on 25/02/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbProductPrice: UILabel!
    
    func prepare(with product: Product) {
        ivPoster.image = product.img
        lbProductName.text = product.name
        lbProductPrice.text = "\(product.value)"
    }
}
