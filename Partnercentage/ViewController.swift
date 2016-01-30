//
//  ViewController.swift
//  Partnercentage
//
//  Created by Raquel Ribeiro on 2016-01-29.
//  Copyright © 2016 Gizmoholic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtPartnerASalary: UITextField!
    @IBOutlet weak var txtPartnerATax: UITextField!
    @IBOutlet weak var txtPartnerBSalary: UITextField!
    @IBOutlet weak var txtPartnerBTax: UITextField!
    @IBOutlet weak var txtTotalIncome: UILabel!
    
    var txtASal:Int = 0, txtBSal:Int = 0, txtATax:Int = 0, txtBTax:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPartnerASalary.delegate = self
        txtPartnerBSalary.delegate = self
        txtPartnerASalary.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        txtPartnerBSalary.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        txtTotalIncome.text = "Total Income: "

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOk(sender: AnyObject) {
        txtASal = Int(txtPartnerASalary.text!)!
        txtBSal = Int(txtPartnerBSalary.text!)!
        
        txtTotalIncome.text = "Total Income: "+String(txtASal+txtBSal)
        
    }
    
    func textFieldDidChange(txtPartnerSalary: UITextField){
        if (txtPartnerASalary.text! != ""){
            txtASal = Int(txtPartnerASalary.text!)!
        }else{
            txtASal = 0
        }
        if (txtPartnerBSalary.text! != ""){
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
