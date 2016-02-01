//
//  ViewController.swift
//  Partnercentage
//
//  Created by Glauber Martins on 2016-01-29.
//  Copyright © 2016 Gizmoholic. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtPartnerASalary: UITextField!
    @IBOutlet weak var txtPartnerATax: UITextField!
    @IBOutlet weak var txtPartnerBSalary: UITextField!
    @IBOutlet weak var txtPartnerBTax: UITextField!
    @IBOutlet weak var txtTotalIncome: UILabel!
    
    var txtASal:Int = 0, txtBSal:Int = 0, txtATax:Int = 0, txtBTax:Int = 0
    
    //var partnerA = [NSManagedObject]()
    //var partnerB = [NSManagedObject]()
    //var total = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPartnerASalary.delegate = self
        txtPartnerBSalary.delegate = self
        txtPartnerASalary.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        txtPartnerBSalary.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        txtTotalIncome.text = "Total Income: "
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOk(sender: AnyObject) {
        /*txtASal = Int(txtPartnerASalary.text!)!
        txtBSal = Int(txtPartnerBSalary.text!)!*/
        
        if txtPartnerASalary.text != "" || txtPartnerBSalary.text != "" {
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            
            do{
                
                //PARTNER A
                let requestA = NSFetchRequest(entityName: "PartnerA")
                let resultsA = try context.executeFetchRequest(requestA)
                
                if resultsA.count > 0 {
                    let partner1 = resultsA[0] as! NSManagedObject
                    partner1.setValue(Int(txtPartnerASalary.text!)!, forKey: "salary")
                    partner1.setValue(1, forKey: "tax")
                    do{
                        try partner1.managedObjectContext?.save()
                    }catch{
                        let saveError = error as NSError
                        print(saveError)
                    }
                    NSLog("if")
                    for itemsA in resultsA as! [NSManagedObject]{
                        let sal = itemsA.valueForKey("salary")
                        let tax = itemsA.valueForKey("tax")
                        
                        print(sal!, tax!)
                    }
                    //print(resultsA)
                }else{
                    let newPartner = NSEntityDescription.insertNewObjectForEntityForName("PartnerA", inManagedObjectContext: context)
                    newPartner.setValue(Int(txtPartnerASalary.text!)!, forKey: "salary")
                    newPartner.setValue(1, forKey: "tax")
                    
                    try context.save()
                    
                    NSLog("else")
                }
                
                //PARTNER B
                let requestB = NSFetchRequest(entityName: "PartnerB")
                let resultsB = try context.executeFetchRequest(requestB)
                
                if resultsB.count > 0 {
                    let partner2 = resultsB[0] as! NSManagedObject
                    partner2.setValue(Int(txtPartnerBSalary.text!)!, forKey: "salary")
                    partner2.setValue(1, forKey: "tax")
                    do{
                        try partner2.managedObjectContext?.save()
                    }catch{
                        let saveError = error as NSError
                        print(saveError)
                    }
                    NSLog("if")
                    for itemsB in resultsB as! [NSManagedObject]{
                        let sal = itemsB.valueForKey("salary")
                        let tax = itemsB.valueForKey("tax")
                        
                        print(sal!, tax!)
                    }
                    //print(resultsA)
                }else{
                    let newPartner = NSEntityDescription.insertNewObjectForEntityForName("PartnerB", inManagedObjectContext: context)
                    newPartner.setValue(Int(txtPartnerBSalary.text!)!, forKey: "salary")
                    newPartner.setValue(1, forKey: "tax")
                    
                    try context.save()
                    
                    NSLog("else")
                }
            }catch let error as NSError{
                NSLog("Could not save \(error), \(error.userInfo)")
            }
        }else{
            
        }
        
        
        
        //let entityA = NSEntityDescription.entityForName("PartnerA", inManagedObjectContext: context)
        
        //entityA!.setValue(Int(txtPartnerASalary.text!)!, forKey: "salary")
        //entityA!.setValue(0, forKey: "tax")
        /*
        //INSERTING
        do{
            try context.save()
        }catch let error as NSError{
            NSLog("Could not save \(error), \(error.userInfo)")
        }
        
        //FETCHING
        do{
            let request = NSFetchRequest(entityName: "PartnerA")
            let result = try context.executeFetchRequest(request)
            
            if result.count > 0{
                for item in result as! [NSManagedObject]{
                    let sal = item.valueForKey("salary")
                    let tax = item.valueForKey("tax")
                    
                    print(sal!, tax!)
                }
            }
            
        }catch let error as NSError{
            NSLog("Could not save \(error), \(error.userInfo)")
        }*/
        
        //let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        //print("Possible sqlite file: \(urls)")
        
        
    }
    
    func textFieldDidChange(txtPartnerSalary: UITextField){
        if txtPartnerASalary.text! != "" {
            txtASal = Int(txtPartnerASalary.text!)!
        }else{
            txtASal = 0
        }
        if txtPartnerBSalary.text! != "" {
            txtBSal = Int(txtPartnerBSalary.text!)!
        }else{
            txtBSal = 0
        }
        txtTotalIncome.text = "Total Income: "+String(txtASal+txtBSal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtPartnerASalary.resignFirstResponder()
        txtPartnerBSalary.resignFirstResponder()
        txtPartnerATax.resignFirstResponder()
        txtPartnerBTax.resignFirstResponder()
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
