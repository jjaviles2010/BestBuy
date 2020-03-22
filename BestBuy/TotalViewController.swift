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
                let valueWithTax = (p.value * state.tax / 100) + p.value
                totalDolar += valueWithTax
            
                if p.usedCard {
                    let valueInReal = (valueWithTax * (cotacao! as NSString).doubleValue)
                    let valueInRealWithIOF = ((iof! as NSString).doubleValue * valueInReal / 100) + valueInReal
                       totalReal += valueInRealWithIOF
                } else {
                    let valueInReal = (valueWithTax * (cotacao! as NSString).doubleValue)
                     totalReal += valueInReal
                }
                
            }
                             
        
        lbTotalDolar.text = String(format: "%.3f", totalDolar)
        lbTotalReal.text = String(format: "%.3f", totalReal)
    }
    

}

extension TotalViewController: NSFetchedResultsControllerDelegate {
    
}
