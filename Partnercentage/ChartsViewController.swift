//
//  ChartsViewController.swift
//  Partnercentage
//
//  Created by Glauber Martins on 2016-02-02.
//  Copyright © 2016 Gizmoholic. All rights reserved.
//

import UIKit

class ChartsViewController: UIViewController {

    @IBOutlet weak var timeControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var averageSpent: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var monthsContainer: UIView!
    @IBOutlet weak var yearContainer: UIView!
    @IBOutlet weak var sixMonthsContainer: UIView!



    var costSum = 0
    var total = 0
    var totalAux = 0
    
    var averageData: [Int] = []
    
    var chartData:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(chartData, total)
        
        //3 MONTHS MATH ALGORITHM
        var auxData:[Int] = []
        totalAux = total * 3

        var multiplied = 0
        for i in chartData {
            multiplied += i
        }
        auxData.append(multiplied)
        multiplied = auxData.first! * 2
        auxData.append(multiplied)
        multiplied = auxData.first! * 3
        auxData.append(multiplied)
        
        print(chartData)
        
        lineChartView.totalIncome = totalAux
        lineChartView.chartPoints = auxData
        
        averageData = auxData
        
        setupChartDisplay()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeTime(sender: AnyObject) {
        //print(timeControl.selectedSegmentIndex)
        
        switch timeControl.selectedSegmentIndex {
        case 0:
            //3 MONTHS MATH ALGORITHM
            var auxData:[Int] = []
            totalAux = total * 3
            
            var multiplied = 0
            for i in chartData {
                multiplied += i
            }
            auxData.append(multiplied)
            multiplied = auxData.first! * 2
            auxData.append(multiplied)
            multiplied = auxData.first! * 3
            auxData.append(multiplied)
            
            lineChartView.totalIncome = totalAux
            lineChartView.chartPoints = auxData
            averageData = auxData
            
            monthsContainer.hidden = false
            sixMonthsContainer.hidden = true
            yearContainer.hidden = true
            
        case 1:
            //6 MONTHS MATH ALGORITHM
            var auxData:[Int] = []
            totalAux = total * 6

            var multiplied = 0
            for i in chartData {
                multiplied += i
            }
            multiplied = multiplied * 2
            auxData.append(multiplied)
            multiplied = auxData.first! * 2
            auxData.append(multiplied)
            multiplied = auxData.first! * 3
            auxData.append(multiplied)
            
            lineChartView.totalIncome = totalAux
            lineChartView.chartPoints = auxData
            averageData = auxData
            
            monthsContainer.hidden = true
            sixMonthsContainer.hidden = false
            yearContainer.hidden = true
            
        case 2:
            //1 YEAR MATH ALGORITHM
            var auxData:[Int] = []
            totalAux = total * 12

            var multiplied = 0
            for i in chartData {
                multiplied += i
            }
            multiplied = multiplied * 3
            auxData.append(multiplied)
            multiplied = auxData.first! * 2
            auxData.append(multiplied)
            multiplied = auxData.first! * 3
            auxData.append(multiplied)
            multiplied = auxData.first! * 4
            auxData.append(multiplied)
            
            lineChartView.totalIncome = totalAux
            lineChartView.chartPoints = auxData
            averageData = auxData
            
            monthsContainer.hidden = true
            sixMonthsContainer.hidden = true
            yearContainer.hidden = false
            
        default: break
            
        }
        
        lineChartView.setNeedsDisplay()
        setupChartDisplay()
        
    }
    
    func setupChartDisplay() {
        
        maxLabel.text = "\(lineChartView.totalIncome)"
        
        //SETS MONTHLY SPENT AVERAGE
        averageSpent.text = "\(averageData.first!)"
        
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
