//
//  ViewController.swift
//  SportsStore
//
//  Created by Tim Pryor on 2015-08-26.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import UIKit




class ProductTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stockStepper: UIStepper!
    @IBOutlet weak var stockField: UITextField!
    
    var product: Product?
    
}

var handler = { (p:Product) in
    println("Change: \(p.name) \(p.stockLevel) items in stock")
}


class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var totalStockLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var productStore = ProductDataStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        displayStockTotal()
        //this was set in the storyboard
        //tableView.dataSource = self
        
        //&Tutor: question&
        productStore.callback = { (p: Product) in
            for cell in self.tableView.visibleCells() {
                if let pcell = cell as? ProductTableCell {
                    if pcell.product?.name == p.name {
                        pcell.stockStepper.value = Double(p.stockLevel)
                        pcell.stockField.text = String(p.stockLevel)
                    }
                }
            }
            self.displayStockTotal()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productStore.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let product = productStore.products[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell") as! ProductTableCell
        cell.product = product
        cell.nameLabel.text = product.name
        
        cell.descriptionLabel.text = product.productDescription
        
        cell.descriptionLabel.text = product.description
        cell.stockStepper.value = Double(product.stockLevel)
        cell.stockField.text = String(product.stockLevel)
        return cell
    }
    
    
    
    @IBAction func stockLevelDidChange(sender: AnyObject) {
        
        // as? returns nil if not UIView
        // assigns sender to currentCell if sender is subclass of UIView
        if var currentCell = sender as? UIView {
            
            while (true) {
                
                currentCell = currentCell.superview!.superview!
             
                if let cell = currentCell as? ProductTableCell {
                    
                    if let product = cell.product {
                        
                        if let stepper = sender as? UIStepper {
                            product.stockLevel = Int(stepper.value)
                        
                        } else if let textfield = sender as? UITextField {
            
                                if let newValue = textfield.text.toInt() {
                                    
                                    product.stockLevel = newValue
                                }
                        }
                        
                        cell.stockStepper.value = Double(product.stockLevel)
                        cell.stockField.text = String(product.stockLevel)
                        
                        productLogger.logItem(product)
                    }
                    
                    break
                }
            }
            displayStockTotal()
        }
    }
    
    // uses the reduce extension from the Swift standard library
    // this invokes a function for each item in the array
    // totals the value at index 4 for each data tuple
    
    func displayStockTotal() {
        /*
        let stockTotal = products.reduce(0, combine: {
            (total, product) -> Int in
            return total + product.stockLevel
        })
        
        totalStockLabel.text = "\(stockTotal) Products in Stock"
        */
        
    
        // Tuples allow us to generate two total values for each iteration of reduce.
        
        let finalTotals: (Int, Double) = productStore.products.reduce((0, 0.0), combine: {
            (totals, product) -> (Int, Double) in
                return (totals.0 + product.stockLevel, totals.1 + product.stockValue)
        })
        
        totalStockLabel.text = "\(finalTotals.0) Products in Stock. " +
            "Total Value: \(Utils.currencyStringFromNumber(finalTotals.1))"

    }
    
}

