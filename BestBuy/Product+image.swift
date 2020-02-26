//
//  Product+image.swift
//  BestBuy
//
//  Created by Jose Javier Aviles Gomez on 25/02/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import Foundation
import UIKit

extension Product {
    var img: UIImage? {
        return self.image as? UIImage
    }
}
