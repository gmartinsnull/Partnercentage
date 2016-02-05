//
//  LineChartView.swift
//  Partnercentage
//
//  Created by Glauber Martins on 2016-02-02.
//  Copyright © 2016 Gizmoholic. All rights reserved.
//

import UIKit
//import CoreData

var totalIncomeInit = 5000
var chartPointsInit:[Int] = [0]

@IBDesignable class LineChartView: UIView {
    
    @IBInspectable var chartPoints:[Int] = [0, 3000] {
        didSet {
            if chartPoints.count <= chartPointsInit.count {
                setNeedsDisplay()
            }
        }
    }
    
    //CHANGE TOTAL INCOME FROM CHARTSVIEWCONTROLLER
    @IBInspectable var totalIncome: Int = 5000 {
        didSet {
            if totalIncomeInit != totalIncome{
                //REFRESH VIEW
                setNeedsDisplay()
            }
        }
    }
    
    //GRADIENT'S COLORS
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        //print(chartPoints, totalIncome)
        
        let width = rect.width
        let height = rect.height
        
        //SET UP ROUND CORNERS
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        //GET CONTEXT
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //SET UP COLOR SPACE
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //SET UP COLOR RATIO
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //CREATES THE GRADIENT
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
        //DRAWS THE GRADIENT
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            CGGradientDrawingOptions(rawValue: 0))
        
        //CALCULATES X POINT
        let margin:CGFloat = 20.0
        let columnXPoint = { (column:Int) -> CGFloat in
            //CALCULATES GAP BTW POINTS
            let spacer = (width - margin*2 - 4) / CGFloat((self.chartPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        //CALCULATES Y POINT
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        //SET MAX
        //let maxValue = chartPoints.maxElement()
        let maxValue = totalIncome
        
        let columnYPoint = { (chartPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(chartPoint) /
                CGFloat(maxValue) * graphHeight
            //FLIPS THE CHART
            y = graphHeight + topBorder - y
            return y
        }
        
        //DRAW THE CHART
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        //SET UP POINTS
        let chartPath = UIBezierPath()
        //GET TO THE START POINT
        chartPath.moveToPoint(CGPoint(x:columnXPoint(0),
            y:columnYPoint(chartPoints[0])))
        
        //SET DOTS FOR EVERY ITEM IN THE chartPoints ARRAY ACCORDING TO THE X,Y
        for i in 1..<chartPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                y:columnYPoint(chartPoints[i]))
            chartPath.addLineToPoint(nextPoint)
        }
        
        //CREATES A SECOND GRADIENT AND CLIPS IT
        
        //SAVES CONTEXT STATE
        CGContextSaveGState(context)
        
        //CREATES A COPY OF THE PATH TO CLIP
        let clippingPath = chartPath.copy() as! UIBezierPath
        
        //SETS LINES ON TE COPIED PATH TO SET THE LIMIT OF THE GRATIENT
        clippingPath.addLineToPoint(CGPoint(
            x: columnXPoint(chartPoints.count - 1),
            y:height))
        clippingPath.addLineToPoint(CGPoint(
            x:columnXPoint(0),
            y:height))
        clippingPath.closePath()
        
        //ADD CLIP TO THE CONTEXT
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 0))
        CGContextRestoreGState(context)
        
        //DRAWS THE LINE ON THE CLIPPED PATH
        chartPath.lineWidth = 2.0
        chartPath.stroke()
        
        //SET THE DOTS
        for i in 0..<chartPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(chartPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect:
                CGRect(origin: point,
                    size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin,
            y:topBorder))
        
        //center line
        linePath.moveToPoint(CGPoint(x:margin,
            y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.moveToPoint(CGPoint(x:margin,
            y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }

}
