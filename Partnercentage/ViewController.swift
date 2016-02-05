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
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var partnerALabel: UILabel!
    @IBOutlet weak var partnerBLabel: UILabel!
    @IBOutlet weak var salaryALabel: UILabel!
    @IBOutlet weak var salaryBLabel: UILabel!
    
    var partASal:Int = 0, partBSal:Int = 0, partATax:Int = 0, partBTax:Int = 0, totalIncome:Int = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPartnerASalary.delegate = self
        txtPartnerBSalary.delegate = self
        txtPartnerASalary.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        txtPartnerBSalary.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        //CIRCLE BUTTON
        btnOk.layer.cornerRadius = 0.5 * btnOk.bounds.size.width
        
        
        txtPartnerASalary.text = defaults.stringForKey("partnerASalary")
        txtPartnerBSalary.text = defaults.stringForKey("partnerBSalary")
        
        if (defaults.stringForKey("partnerASalary") != nil) {
            partASal = Int(defaults.stringForKey("partnerASalary")!)!
        }
        if (defaults.stringForKey("partnerBSalary") != nil) {
            partBSal = Int(defaults.stringForKey("partnerBSalary")!)!
        }
        if (defaults.stringForKey("total") != nil) {
            txtTotalIncome.text = defaults.stringForKey("total")
            totalIncome = partASal+partBSal
        }else{
            txtTotalIncome.text = "Total Income: $ "
        }
        
        
        
        self.navigationController?.navigationBarHidden = true
        

        //BUTTON ANIMATION
        rotateButton()
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        //ANIMATION
        partnerALabel.alpha = 0
        salaryALabel.center.x -= view.bounds.width
        txtPartnerASalary.center.x -= view.bounds.width
        partnerBLabel.alpha = 0
        salaryBLabel.center.x += view.bounds.width
        txtPartnerBSalary.center.x += view.bounds.width
        

        
        //ANIMATIONS
        UIView.animateWithDuration(1.0, animations: {
            //self.partnerALabel.center.x += self.view.bounds.width
            self.salaryALabel.center.x += self.view.bounds.width
            self.txtPartnerASalary.center.x += self.view.bounds.width
            //self.partnerBLabel.center.x -= self.view.bounds.width
            self.salaryBLabel.center.x -= self.view.bounds.width
            self.txtPartnerBSalary.center.x -= self.view.bounds.width
        })
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //ANIMATIONS
        UIView.animateWithDuration(1.0, delay: 1.0, options: [], animations: {
            self.partnerALabel.alpha = 1.0
            self.partnerBLabel.alpha = 1.0
            }, completion: nil)
    }
    
    func rotateButton(){
        UIView.animateWithDuration(2.0, delay: 1.0, options: [], animations: { () -> Void in
            self.btnOk.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.btnOk.center.y += self.view.bounds.height
            }, completion:nil)
        UIView.animateWithDuration(2.0, delay: 1.0, options: [], animations: { () -> Void in
            self.btnOk.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
            }, completion:nil)
        UIView.animateWithDuration(2.0, delay: 1.0, options: [], animations: { () -> Void in
            self.btnOk.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            }, completion:nil)
        UIView.animateWithDuration(2.0, delay: 1.0, options: [], animations: { () -> Void in
            self.btnOk.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
            }, completion:nil)
        UIView.animateWithDuration(2.0, delay: 1.0, options: [], animations: { () -> Void in
            self.btnOk.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            }, completion:nil)
        UIView.animateWithDuration(2.0, delay: 1.0, options: [], animations: { () -> Void in
            self.btnOk.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
            }, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOk(sender: AnyObject) {
        
        if txtPartnerASalary.text != "" || txtPartnerBSalary.text != "" {
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            
            do{
                
                //SAVE PARTNER A IN CORE DATA
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
                }else{
                    let newPartner = NSEntityDescription.insertNewObjectForEntityForName("PartnerA", inManagedObjectContext: context)
                    newPartner.setValue(Int(txtPartnerASalary.text!)!, forKey: "salary")
                    newPartner.setValue(1, forKey: "tax")
                    
                    try context.save()
                    
                    //NSLog("else")
                }
                
                //SAVE PARTNER B IN CORE DATA
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
                }else{
                    let newPartner = NSEntityDescription.insertNewObjectForEntityForName("PartnerB", inManagedObjectContext: context)
                    newPartner.setValue(Int(txtPartnerBSalary.text!)!, forKey: "salary")
                    newPartner.setValue(1, forKey: "tax")
                    
                    try context.save()
                    
                }
            }catch let error as NSError{
                NSLog("Could not save \(error), \(error.userInfo)")
            }
        }else{
            
        }
        
        //SET USER DEFAULTS
        
        defaults.setObject(txtPartnerASalary.text, forKey: "partnerASalary")
        defaults.setObject(txtPartnerATax.text, forKey: "partnerATax")
        defaults.setObject(txtPartnerBSalary.text, forKey: "partnerBSalary")
        defaults.setObject(txtPartnerBTax.text, forKey: "partnerBTax")
        defaults.setObject(txtTotalIncome.text, forKey: "total")
        
    }
    
    func textFieldDidChange(txtPartnerSalary: UITextField){
        if txtPartnerASalary.text! != "" {
            partASal = Int(txtPartnerASalary.text!)!
        }else{
            partASal = 0
        }
        if txtPartnerBSalary.text! != "" {
            partBSal = Int(txtPartnerBSalary.text!)!
        }else{
            partBSal = 0
        }
        totalIncome = partASal+partBSal
        txtTotalIncome.text = "Total Income: $ "+String(partASal+partBSal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtPartnerASalary.resignFirstResponder()
        txtPartnerBSalary.resignFirstResponder()
        txtPartnerATax.resignFirstResponder()
        txtPartnerBTax.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "partnersDataSegue" {
            if let destination = segue.destinationViewController as? BillsViewController {
                let partAShare = Double(Double(partASal)/Double(totalIncome))
                let partBShare = Double(Double(partBSal)/Double(totalIncome))
                destination.partnerAShare = partAShare
                destination.partnerBShare = partBShare
                destination.totalInc = totalIncome
            }
        }
    }

}
