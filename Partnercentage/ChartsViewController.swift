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
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var averageSpent: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var monthsContainer: UIView!
    @IBOutlet weak var yearContainer: UIView!
    @IBOutlet weak var sixMonthsContainer: UIView!
    
    @IBOutlet weak var subtitlesView: UIView!

    var isPieChartViewShowing = false

    var costSum = 0
    var total = 0
    var totalAux = 0
    
    var averageData: [Int] = []
    
    var chartData:[Int] = []
    
    var chartLabels:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(chartData, total)
        
        //PIE CHART DATA TRANSFER
        pieChartView.pieData = chartData
        pieChartView.totalIncome = total
        
        //SET UP PIE CHART SUBTITLES
        addSubtitleView()
        
        //LINE CHART DATA TRANSFER
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
        
        //print(chartData)
        
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
    
    @IBAction func lineChartViewTap(gesture:UITapGestureRecognizer?) {
        if (!isPieChartViewShowing) {
            
            //SHOW PIE CHART
            UIView.transitionFromView(lineChartView,
                toView: pieChartView,
                duration: 1.0,
                options: [UIViewAnimationOptions.TransitionFlipFromLeft, UIViewAnimationOptions.ShowHideTransitionViews], completion:nil)
            UIView.animateWithDuration(1.0, animations: {
                self.timeControl.alpha = 0.0
                self.subtitlesView.alpha = 1.0
            })
        } else {
            
            //HIDE PIE CHART
            UIView.transitionFromView(pieChartView,
                toView: lineChartView,
                duration: 1.0,
                options: [UIViewAnimationOptions.TransitionFlipFromRight, UIViewAnimationOptions.ShowHideTransitionViews], completion: nil)
            UIView.animateWithDuration(1.0, animations: {
                self.timeControl.alpha = 1.0
                self.subtitlesView.alpha = 0.0
            })
        }
        isPieChartViewShowing = !isPieChartViewShowing
    }
    
    @IBAction func chartsRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformRotate(view.transform, recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    @IBAction func chartsPinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformScale(view.transform,
                recognizer.scale, recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    func addSubtitleView(){
        
        let xSquare:[CGFloat] = [0, 70, 140, 220]
        let xLabel:[CGFloat] = [15, 85, 155, 235]
        var chartDataTemp = chartData
        
        var maxIndexes:[Int] = []
        var colCounter = 1
        if chartData.count > 7 {
            for _ in 1...6{
                let max = CGFloat(chartDataTemp.maxElement()!)
                maxIndexes.append(chartDataTemp.indexOf(Int(max))!)
                chartDataTemp[chartDataTemp.indexOf(Int(max))!] = 0
            }
            //MORE THAN 7
            for x in maxIndexes {
                if colCounter <= 4{
                    let squareFrame : CGRect = CGRectMake(xSquare[colCounter-1],0,15,15)
                    let square : UIView = UIView(frame: squareFrame)
                    square.backgroundColor = getRandomColor(x)
                    square.alpha = 1.0
                    self.subtitlesView.addSubview(square)
                    
                    let label = UILabel(frame: CGRectMake(xLabel[colCounter-1], -3, 60, 20))
                    label.textAlignment = NSTextAlignment.Left
                    label.font = UIFont.systemFontOfSize(15)
                    label.text = chartLabels[x]
                    self.subtitlesView.addSubview(label)
                }else{
                    let squareFrame : CGRect = CGRectMake(xSquare[colCounter-5],20,15,15)
                    let square : UIView = UIView(frame: squareFrame)
                    square.backgroundColor = getRandomColor(x)
                    square.alpha = 1.0
                    self.subtitlesView.addSubview(square)
                    
                    let label = UILabel(frame: CGRectMake(xLabel[colCounter-5], 16, 60, 20))
                    label.textAlignment = NSTextAlignment.Left
                    label.font = UIFont.systemFontOfSize(15)
                    label.text = chartLabels[x]
                    self.subtitlesView.addSubview(label)
                }
                colCounter++
            }
            //CREATES SAVINGS SQUARE AND LABEL
            var squareFrame : CGRect = CGRectMake(xSquare[colCounter-5],20,15,15)
            var square : UIView = UIView(frame: squareFrame)
            square.backgroundColor = getRandomColor(chartData.count)
            square.alpha = 1.0
            self.subtitlesView.addSubview(square)
            
            var label = UILabel(frame: CGRectMake(xLabel[colCounter-5], 16, 60, 20))
            label.textAlignment = NSTextAlignment.Left
            label.font = UIFont.systemFontOfSize(15)
            label.text = "savings"
            self.subtitlesView.addSubview(label)
            
            //CREATES OTHERS SQUARE AND LABEL
            squareFrame = CGRectMake(220,20,15,15)
            square = UIView(frame: squareFrame)
            square.backgroundColor = UIColor.blackColor()
            square.alpha = 1.0
            self.subtitlesView.addSubview(square)
            
            label = UILabel(frame: CGRectMake(235, 16, 60, 20))
            label.textAlignment = NSTextAlignment.Left
            label.font = UIFont.systemFontOfSize(15)
            label.text = "others"
            self.subtitlesView.addSubview(label)
        }else{
            for _ in chartData {
                let max = CGFloat(chartDataTemp.maxElement()!)
                maxIndexes.append(chartDataTemp.indexOf(Int(max))!)
                chartDataTemp[chartDataTemp.indexOf(Int(max))!] = 0
            }
            //MAX 7
            for y in maxIndexes {
                if colCounter <= 4{
                    let squareFrame : CGRect = CGRectMake(xSquare[colCounter-1],0,15,15)
                    let square : UIView = UIView(frame: squareFrame)
                    square.backgroundColor = getRandomColor(y)
                    square.alpha = 1.0
                    self.subtitlesView.addSubview(square)
                    
                    let label = UILabel(frame: CGRectMake(xLabel[colCounter-1], -3, 60, 20))
                    label.textAlignment = NSTextAlignment.Left
                    label.font = UIFont.systemFontOfSize(15)
                    label.text = chartLabels[y]
                    self.subtitlesView.addSubview(label)
                }else{
                    let squareFrame : CGRect = CGRectMake(xSquare[colCounter-5],20,15,15)
                    let square : UIView = UIView(frame: squareFrame)
                    square.backgroundColor = getRandomColor(y)
                    square.alpha = 1.0
                    self.subtitlesView.addSubview(square)
                    
                    let label = UILabel(frame: CGRectMake(xLabel[colCounter-5], 16, 60, 20))
                    label.textAlignment = NSTextAlignment.Left
                    label.font = UIFont.systemFontOfSize(15)
                    label.text = chartLabels[y]
                    self.subtitlesView.addSubview(label)
                }
                colCounter++
            }
            if colCounter <= 4 {
                //CREATES SAVINGS SQUARE AND LABEL
                let squareFrame : CGRect = CGRectMake(xSquare[colCounter-1],0,15,15)
                let square : UIView = UIView(frame: squareFrame)
                square.backgroundColor = getRandomColor(chartData.count)
                square.alpha = 1.0
                self.subtitlesView.addSubview(square)
                
                let label = UILabel(frame: CGRectMake(xLabel[colCounter-1], -3, 60, 20))
                label.textAlignment = NSTextAlignment.Left
                label.font = UIFont.systemFontOfSize(15)
                label.text = "savings"
                self.subtitlesView.addSubview(label)
            }else{
                //CREATES SAVINGS SQUARE AND LABEL
                let squareFrame : CGRect = CGRectMake(xSquare[colCounter-5],20,15,15)
                let square : UIView = UIView(frame: squareFrame)
                square.backgroundColor = getRandomColor(chartData.count)
                square.alpha = 1.0
                self.subtitlesView.addSubview(square)
                
                let label = UILabel(frame: CGRectMake(xLabel[colCounter-5], 16, 60, 20))
                label.textAlignment = NSTextAlignment.Left
                label.font = UIFont.systemFontOfSize(15)
                label.text = "savings"
                self.subtitlesView.addSubview(label)
            }
            
        }
        
        //print(maxIndexes)
        
    }
    
    func getRandomColor(counter: Int) -> UIColor{
        
        let colors:[UIColor] = [UIColor(red:255/255.0, green: 150/255.0, blue: 110/255.0, alpha: 1.0),
            UIColor(red:167/255.0, green: 87/255.0, blue: 255/255.0, alpha: 1.0),
            UIColor(red:255/255.0, green: 68/255.0, blue: 25/255.0, alpha: 1.0),
            UIColor(red:180/255.0, green: 255/255.0, blue: 144/255.0, alpha: 1.0),
            UIColor(red:233/255.0, green: 227/255.0, blue: 255/255.0, alpha: 1.0),
            UIColor(red:205/255.0, green: 173/255.0, blue: 0/255.0, alpha: 1.0),
            UIColor(red:70/255.0, green: 130/255.0, blue: 180/255.0, alpha: 1.0),
            UIColor(red:255/255.0, green: 62/255.0, blue: 150/255.0, alpha: 1.0),
            UIColor(red:139/255.0, green: 90/255.0, blue: 43/255.0, alpha: 1.0),
            UIColor(red:0/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1.0)]
        
        if counter > colors.count {
            let startOver = total % 10
            return colors[startOver - 1]
        }else{
            return colors[counter]
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
