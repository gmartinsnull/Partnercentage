//
//  PieChartView.swift
//  Partnercentage
//
//  Created by Glauber Martins on 2016-02-05.
//  Copyright © 2016 Gizmoholic. All rights reserved.
//

import UIKit

//let billsData:[Int] = [30, 10, 40, 20, 12, 100, 50, 70, 5, 23]
let pieDataInit:[Int] = [0]
let π:CGFloat = CGFloat(M_PI)
let totalIncomePieInit = 300

var total = 0
var count = 0

@IBDesignable class PieChartView: UIView {
    
    @IBInspectable var outlineColor: UIColor = UIColor.blackColor()
    @IBInspectable var chartColor: UIColor = UIColor.redColor()
    
    //CHANGES DATA FROM CHARTSVIEWCONTROLLER
    @IBInspectable var pieData:[Int] = [30, 10, 40, 20] {
        didSet {
            if pieData.count <= pieDataInit.count {
                setNeedsDisplay()
            }
        }
    }
    
    //CHANGE TOTAL INCOME FROM CHARTSVIEWCONTROLLER
    @IBInspectable var totalIncome: Int = 300 {
        didSet {
            if totalIncomePieInit != totalIncome{
                //REFRESH VIEW
                setNeedsDisplay()
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        let center:CGPoint = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius:CGFloat = max(bounds.width, bounds.height)
        let arcWidth: CGFloat = 80
        
        count = 0
        total = 0
        
        
        var startAngle: CGFloat = 0
        var endAngle:CGFloat = 0
        total = totalIncome
        
        //print(total)
        
        let fraction:CGFloat = CGFloat( π / CGFloat(total) * 2.0)
        
        
        
        for j in pieData {
            if count == 0 {
                startAngle = 0
            }else{
                startAngle = endAngle
            }
            count++
            
            endAngle = fraction * CGFloat(j) + startAngle
            
            print(j, count, startAngle, endAngle)
            
            drawFraction(startAngle, end: endAngle)
        }
        
        count++
        drawFraction(endAngle, end: π * 2)
        
    }
        
    func drawFraction(start: CGFloat, end: CGFloat){
        let center:CGPoint = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius:CGFloat = max(bounds.width, bounds.height)
        let arcWidth: CGFloat = 80
        
        // DRAWS THE ARC
        let path = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: start,
            endAngle: end,
            clockwise: true)
        
        path.lineWidth = arcWidth
        chartColor = getRandomColor()
        chartColor.setStroke()
        path.stroke()
        
        //DRAWS OUTLINE
        
        //SETS OUTLINE PATH
        let outlinePath = UIBezierPath(arcCenter: center,
            radius: bounds.width/2,
            startAngle: start,
            endAngle: end,
            clockwise: true)
        
        //DRAWS INNER LINE PATH
        outlinePath.addArcWithCenter(center,
            radius: bounds.width/2 - arcWidth,
            startAngle: end,
            endAngle: start,
            clockwise: false)
        
        //CLOSE PATH
        outlinePath.closePath()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = 2.0
        outlinePath.stroke()
        
    }
        
    func getRandomColor() -> UIColor{
        
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
        
        if count > colors.count {
            let startOver = total % 10
            
            return colors[startOver - 1]
        }else{
            
            return colors[count-1]
        }
    }


}
