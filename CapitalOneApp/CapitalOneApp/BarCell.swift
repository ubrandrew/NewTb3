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
        tv.text = "Budget Breakdown"
        tv.adjustsFontSizeToFitWidth = true
        tv.font = UIFont(name: "Avenir-Medium", size: 15)
        tv.textColor = UIColor.rgb(red: 41, green: 77, blue: 106)
        return tv
    }()
    
    let entLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Entertainment"
        tv.adjustsFontSizeToFitWidth = true
        tv.font = UIFont(name: "Avenir-Medium", size: 10)
        tv.textColor = UIColor.rgb(red: 0, green: 122, blue: 255)
        return tv
    }()
    
    let transLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Transportation"
        tv.adjustsFontSizeToFitWidth = true
        tv.font = UIFont(name: "Avenir-Medium", size: 10)
        tv.textColor = UIColor.rgb(red: 51, green: 148, blue: 255)
        return tv
    }()
    
    let foodLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Food"
        tv.adjustsFontSizeToFitWidth = true
        tv.font = UIFont(name: "Avenir-Medium", size: 10)
        tv.textColor = UIColor.rgb(red: 102, green: 175, blue: 255)
        return tv
    }()
    
    let helLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Health"
        tv.adjustsFontSizeToFitWidth = true
        tv.font = UIFont(name: "Avenir-Medium", size: 10)
        tv.textColor = UIColor.rgb(red: 153, green: 202, blue: 255)
        return tv
    }()
    
    let shopLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Shopping"
        tv.adjustsFontSizeToFitWidth = true
        tv.font = UIFont(name: "Avenir-Medium", size: 10)
        tv.textColor = UIColor.rgb(red: 204, green: 228, blue: 255)
        return tv
    }()
    
    let entImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "entRect")
        return image
    }()
    
    let transImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "transimage")
        return image
    }()
    
    let foodImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "foodimage")
        return image
    }()
    
    let helImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "helimage")
        return image
    }()
    
    let shopImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "shopimage")
        return image
    }()
    
    var plotPoints =
        [
            [
                ORKValueStack(stackedValues: [4])
            ],
            [
                ORKValueStack(stackedValues: [10])
            ],
            [
                ORKValueStack(stackedValues: [5])
            ],
            [
                ORKValueStack(stackedValues: [4])
            ],
            [
                ORKValueStack(stackedValues: [10])
            ],
            [
                ORKValueStack(stackedValues: [5])
            ],
            [
                ORKValueStack(stackedValues: [4])
            ],
            [
                ORKValueStack(stackedValues: [10])
            ],
            [
                ORKValueStack(stackedValues: [5])
            ],
            [
                ORKValueStack(stackedValues: [4])
            ],
            [
                ORKValueStack(stackedValues: [10])
            ],
            [
                ORKValueStack(stackedValues: [5])
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
            return .blue
        case 1:
            return .red
        case 2:
            return .green
        case 3:
            return .black
        case 4:
            return .purple
        case 5:
            return .yellow
        case 6:
            return .gray
        default:
            return .blue

        }
        
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
            switch pointIndex {
            default:
                return "Categories in Budget Breakdown"
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
        graphChartView.showsHorizontalReferenceLines = true
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
        let stackView = UIStackView(arrangedSubviews: [entImage, transImage, foodImage, helImage, shopImage])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 13
        addSubview(stackView)
        
        stackView.anchor(top: textView.bottomAnchor, left: textView.leftAnchor, bottom: nil, right: textView.rightAnchor, paddingTop: -10, paddingLeft: 5, paddingBottom: 0, paddingRight: 119, width: 15, height: 125)
        
        let newStack = UIStackView(arrangedSubviews: [entLabel, transLabel, foodLabel, helLabel, shopLabel])
        newStack.distribution = .fillEqually
        newStack.axis = .vertical
        newStack.spacing = 14
        addSubview(newStack)
        
        newStack.anchor(top: textView.bottomAnchor, left: stackView.rightAnchor, bottom: nil, right: textView.rightAnchor, paddingTop: -9, paddingLeft: 5, paddingBottom: 0, paddingRight: 50, width: 62, height: 124)
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
