//
//  TotalViewController.swift
//  BestBuy
//
//  Created by Gabriel Jesus Santos  on 21/03/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {
    
    @IBOutlet weak var lbTotalDolar: UILabel!
    @IBOutlet weak var lbTotalReal: UILabel!
    
    var fetchedProduct: NSFetchedResultsController<Product>?
    var fetchedState: NSFetchedResultsController<State>?
    var product: [Product]!
    var totalDolar = 0.0
    var totalReal = 0.0
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadProducts()
        calculateTotal()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        totalDolar = 0.0
        totalReal = 0.0
    }
    
    //MARK: - Functions
    
    private func loadProducts() {

        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedProduct = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        fetchedProduct?.delegate = self

        try? fetchedProduct?.performFetch()
    }
    
    func calculateTotal() {
        
        let cotacao = userDefault.string(forKey: "cotacaoDolar")
        let iof = userDefault.string(forKey: "iof")
        
        guard let pro = fetchedProduct?.fetchedObjects else { return }
        
        pro.forEach { (p) in
            guard let state = p.state else { return }
            if p.usedCard {
                var total = (p.value * ((( state.tax * 10) / 100)) + ((iof! as NSString).doubleValue * 10) / 100)
                totalDolar += total + p.value
            } else {
                var total = p.value * (( state.tax * 10) / 100)
                totalDolar += total + p.value
            }
        }
        
        totalReal = totalDolar * (cotacao as! NSString).doubleValue
        
        lbTotalDolar.text = String(totalDolar)
        lbTotalReal.text = String(totalReal)
    }
    

}

extension TotalViewController: NSFetchedResultsControllerDelegate {
    
}
