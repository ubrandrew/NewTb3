//
//  BarCell.swift
//  CapitalOneApp
//
//  Created by Niranjan Senthilkumar on 5/24/18.
//  Copyright © 2018 NJ. All rights reserved.
//
import UIKit
import ResearchKit

class BarCell: UICollectionViewCell, ORKValueStackGraphChartViewDataSource{
    
    let textView: UILabel = {
        let tv = UILabel()
        tv.text = "Places Most Spent"
        tv.adjustsFontSizeToFitWidth = true
        tv.font = UIFont(name: "Avenir-Medium", size: 15)
        tv.textColor = .black
        return tv
    }()
    
    let entLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Gamestop - $60"
        tv.adjustsFontSizeToFitWidth = true
        tv.font = UIFont(name: "Avenir-Medium", size: 10)
        tv.textColor = UIColor.rgb(red: 215, green: 25, blue: 28)
        return tv
    }()
    
    let transLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Pharmacy - $90"
        tv.font = UIFont(name: "Avenir-Medium", size: 10)
        tv.textColor = UIColor.rgb(red: 253, green: 174, blue: 97)
        return tv
    }()
    
    let foodLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Trader Joes - $150"
        tv.adjustsFontSizeToFitWidth = true
        tv.font = UIFont(name: "Avenir-Medium", size: 10)
        tv.textColor = UIColor.rgb(red: 77, green: 175, blue: 74)
        return tv
    }()

    
    let entImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "entRect")
        return image
    }()
    
    let transImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "transImage")
        return image
    }()
    
    let foodImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "foodImage")
        return image
    }()

    var plotPoints =
        [
            [
                ORKValueStack(stackedValues: [60])
            ],
            [
                ORKValueStack(stackedValues: [60])
            ],
            [
                ORKValueStack(stackedValues: [60])
            ],
            [
                ORKValueStack(stackedValues: [60])
            ],
            [
                ORKValueStack(stackedValues: [90])
            ],
            [
                ORKValueStack(stackedValues: [90])
            ],
            [
                ORKValueStack(stackedValues: [90])
            ],
            [
                ORKValueStack(stackedValues: [90])
            ],
            [
                ORKValueStack(stackedValues: [150])
            ],
            [
                ORKValueStack(stackedValues: [150])
            ],
            [
                ORKValueStack(stackedValues: [150])
            ],
            [
                ORKValueStack(stackedValues: [150])
            ]
    ]
    
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return plotPoints[plotIndex].count
    }
    
    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return plotPoints.count
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueStack {
        return plotPoints[plotIndex][pointIndex]
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, colorForPlotIndex plotIndex: Int) -> UIColor {
        switch plotIndex {
        case 0:
            return UIColor.rgb(red: 215, green: 25, blue: 28)
        case 1:
            return UIColor.rgb(red: 215, green: 25, blue: 28)
        case 2:
            return UIColor.rgb(red: 215, green: 25, blue: 28)
        case 3:
            return UIColor.rgb(red: 215, green: 25, blue: 28)
        case 4:
            return UIColor.rgb(red: 253, green: 174, blue: 97)
        case 5:
            return UIColor.rgb(red: 253, green: 174, blue: 97)
        case 6:
            return UIColor.rgb(red: 253, green: 174, blue: 97)
        case 7:
            return UIColor.rgb(red: 253, green: 174, blue: 97)
        case 8:
            return UIColor.rgb(red: 77, green: 175, blue: 74)
        case 9:
            return UIColor.rgb(red: 77, green: 175, blue: 74)
        case 10:
            return UIColor.rgb(red: 77, green: 175, blue: 74)
        case 11:
            return UIColor.rgb(red: 77, green: 175, blue: 74)
        default:
            return .white
        }
        
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
            switch pointIndex {
            default:
                return " Categories "
        }
        
    }
    
    let graphChartView: ORKBarGraphChartView = {
        let bc = ORKBarGraphChartView()
        return bc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupChannelCell()
        
        
        graphChartView.dataSource = self
        graphChartView.showsHorizontalReferenceLines = true
        graphChartView.showsVerticalReferenceLines = true
        graphChartView.axisColor = .white
        graphChartView.verticalAxisTitleColor = .orange
        graphChartView.showsVerticalReferenceLines = true
        graphChartView.scrubberLineColor = .red
        
        addSubview(graphChartView)
        graphChartView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 11, paddingLeft: 101, paddingBottom: 11, paddingRight: 0, width: 120, height: 500)
        
        graphChartView.animate(withDuration: 1)

        addSubview(textView)
        textView.anchor(top: graphChartView.topAnchor, left: graphChartView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -15, paddingLeft: 2, paddingBottom: 167, paddingRight: 4, width: 0, height: 0)
        
        
        
        setupColors()
    }
    
    func setupColors(){
        let stackView = UIStackView(arrangedSubviews: [entImage, transImage, foodImage])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 17
        addSubview(stackView)
        
        stackView.anchor(top: textView.bottomAnchor, left: nil, bottom: nil, right: textView.rightAnchor, paddingTop: -8, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 15, height: 70)
        
        let newStack = UIStackView(arrangedSubviews: [entLabel, transLabel, foodLabel])
        newStack.distribution = .fillEqually
        newStack.axis = .vertical
        newStack.alignment = .trailing
        newStack.spacing = 16
        addSubview(newStack)
        
        newStack.anchor(top: textView.bottomAnchor, left: nil, bottom: nil, right: stackView.leftAnchor, paddingTop: -9, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 72, height: 69)

    }

    
    func setupChannelCell(){
        
        backgroundColor = .white
        //layer.masksToBounds = true
        layer.cornerRadius = 6
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
