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

class BillsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var bills = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //FETCH BILLS FOR TABLEVIEW
        do{
            let request = NSFetchRequest(entityName: "Bills")
            let results = try context.executeFetchRequest(request)
            
            bills = results as! [NSManagedObject]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
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
        NSLog("test")
        return bills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let bill = bills[indexPath.row]
        
        let cellTextName = (bill.valueForKey("name") as? String)! + " | $ "
        let cellTextValue = bill.valueForKey("value")!.description + " | "
        let cellTextTax = bill.valueForKey("tax")!.description + " %"
        
        cell!.textLabel!.text = cellTextName + cellTextValue + cellTextTax
        
        print(bills[indexPath.row])
        
        return cell!
    }
    
    @IBAction func addBill(sender: AnyObject) {
        let alertController = UIAlertController(title: "New Bill", message: nil, preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){
            UIAlertAction in
            
            let nameTxtField = alertController.textFields![0] as UITextField
            let valueTxtField = alertController.textFields![1] as UITextField
            let taxTxtField = alertController.textFields![2] as UITextField
            
            let newBill = NSEntityDescription.insertNewObjectForEntityForName("Bills", inManagedObjectContext: context)
            
            newBill.setValue(nameTxtField.text, forKey: "name")
            newBill.setValue(Int(valueTxtField.text!)!, forKey: "value")
            newBill.setValue(1, forKey: "tax")
            //newBill.setValue(Int(taxTxtField.text!)!, forKey: "tax")
            
            do{
                try context.save()
                self.tableView?.reloadData()
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
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
            textField.keyboardType = .PhonePad
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                ok.enabled = textField.text != ""
            }
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Tax"
            textField.keyboardType = .PhonePad
        }
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
