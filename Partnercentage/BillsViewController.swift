//
//  BillsViewController.swift
//  Partnercentage
//
//  Created by Glauber Martins on 2016-01-30.
//  Copyright © 2016 Gizmoholic. All rights reserved.
//

import UIKit
import CoreData

let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let context:NSManagedObjectContext = appDel.managedObjectContext

class BillsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtPartnerBShare: UIBarButtonItem!
    @IBOutlet weak var txtPartnerAShare: UIBarButtonItem!
    
    var bills = [NSManagedObject]()
    
    var partnerAShare:Double = 0
    var partnerBShare:Double = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //let txt:String
        //txt = String(partnerAShare)
        
        //FETCH BILLS FOR TABLEVIEW
        do{
            let request = NSFetchRequest(entityName: "Bills")
            let results = try context.executeFetchRequest(request)
            
            bills = results as! [NSManagedObject]
            
            for item in results as! [NSManagedObject]{
                let val = item.valueForKey("value") as? Int
                total += val!
            }
            
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        //CALCULATES THE AMOUNT FOR EACH PARTNER
        //self.txtPartnerAShare.title = "Partner A: $ "+String(format: "%.2f", partnerAShare)
        self.txtPartnerAShare.title = "Partner A: $ "+String(format: "%.2f", Double(partnerAShare)*Double(total))
        self.txtPartnerBShare.title = "Partner B: $ "+String(format: "%.2f", Double(partnerBShare)*Double(total))
        
        //FETCH PARTNERS DATA
        /*do{
            let requestA = NSFetchRequest(entityName: "PartnerA")
            let resultsA = try context.executeFetchRequest(requestA)
            let requestB = NSFetchRequest(entityName: "PartnerB")
            let resultsB = try context.executeFetchRequest(requestB)
            
            partnersA = resultsA as! [NSManagedObject]
            
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        
        //CHECKING BILLS
        do{
            
            //BILLS
            let request = NSFetchRequest(entityName: "Bills")
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for items in results as! [NSManagedObject]{
                    let name = items.valueForKey("name")
                    let val = items.valueForKey("value")
                    let tax = items.valueForKey("tax")
                    
                    print(name!, val!, tax!)
                }
                NSLog("bills / if")
                //print(resultsA)
            }else{
                
                NSLog("bills / else")
            }
        }catch let error as NSError{
            NSLog("Could not save \(error), \(error.userInfo)")
        }*/

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let bill = bills[indexPath.row]
        
        let cellTextName = (bill.valueForKey("name") as? String)! + " | $ "
        let cellTextValue = bill.valueForKey("value")!.description + " | "
        let cellTextTax = bill.valueForKey("tax")!.description + " %"
        
        cell!.textLabel!.text = cellTextName + cellTextValue + cellTextTax
        
        //print(bills[indexPath.row])
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle{
            case .Delete:
                //UPDATES PARTNERS'S VALUES
                //CALCULATES THE AMOUNT FOR EACH PARTNER
                let bill = bills[indexPath.row]
                print(bill.valueForKey("value")!.description)
                total -= Int(bill.valueForKey("value")!.description)!
                //self.txtPartnerAShare.title = "Partner A: $ "+String(format: "%.2f", partnerAShare)
                self.txtPartnerAShare.title = "Partner A: $ "+String(format: "%.2f", Double(partnerAShare)*Double(total))
                self.txtPartnerBShare.title = "Partner B: $ "+String(format: "%.2f", Double(partnerBShare)*Double(total))
                
                //REMOVE FROM DATA
                context.deleteObject(bills[indexPath.row] as NSManagedObject)
                bills.removeAtIndex(indexPath.row)
                
                do{
                   try context.save()
                }catch let error as NSError{
                    NSLog("Could not save \(error), \(error.userInfo)")
                }
                
                //REMOVE FROM TABLEVIEW
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            default:
                return
        }
    }
    
    @IBAction func addBill(sender: AnyObject) {
        let alertController = UIAlertController(title: "New Bill", message: nil, preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default){
            UIAlertAction in
            
            let nameTxtField = alertController.textFields![0] as UITextField
            let valueTxtField = alertController.textFields![1] as UITextField
            //let taxTxtField = alertController.textFields![2] as UITextField
            
            self.saveBill(nameTxtField.text!, value: Int(valueTxtField.text!)!, tax: 1)
            self.tableView.reloadData()
            
        }
        
        ok.enabled = false
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){
            UIAlertAction in
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Value"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                ok.enabled = textField.text != ""
            }
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Tax"
        }
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveBill(name: String, value: Int, tax: Int){
        let entityBill = NSEntityDescription.entityForName("Bills", inManagedObjectContext: context)
        let newBill = NSManagedObject(entity: entityBill!, insertIntoManagedObjectContext: context)
        
        newBill.setValue(name, forKey: "name")
        newBill.setValue(value, forKey: "value")
        newBill.setValue(tax, forKey: "tax")
        
        do{
            try context.save()
            bills.append(newBill)
            
            //CALCULATES THE AMOUNT FOR EACH PARTNER
            total += value
            //self.txtPartnerAShare.title = "Partner A: $ "+String(format: "%.2f", partnerAShare)
            self.txtPartnerAShare.title = "Partner A: $ "+String(format: "%.2f", Double(partnerAShare)*Double(total))
            self.txtPartnerBShare.title = "Partner B: $ "+String(format: "%.2f", Double(partnerBShare)*Double(total))

        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
