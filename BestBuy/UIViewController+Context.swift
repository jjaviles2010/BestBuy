//
//  UIViewController+Context.swift
//  BestBuy
//
//  Created by Jose Javier Aviles Gomez on 25/02/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
