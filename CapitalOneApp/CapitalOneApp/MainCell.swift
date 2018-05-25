//
//  MainCell.swift
//  CapitalOneApp
//
//  Created by Niranjan Senthilkumar on 5/24/18.
//  Copyright © 2018 NJ. All rights reserved.
//
import UIKit
import ResearchKit

class MainCell: UICollectionViewCell, ORKPieChartViewDataSource {
    
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
    
    
    enum PieChartSegment: Int {
        case Entertainment, Transportation, Food, Health, Shopping
    }

    func numberOfSegments(in pieChartView: ORKPieChartView) -> Int {
        return 5
    }

    func pieChartView(_ pieChartView: ORKPieChartView, valueForSegmentAt index: Int) -> CGFloat {
        switch PieChartSegment(rawValue: index)! {
        case .Entertainment:
            return 30
        case .Transportation:
            return 20
        case .Food:
            return 10
        case .Health:
            return 30
        case .Shopping:
            return 10
        }
    }

    func pieChartView(
        pieChartView: ORKPieChartView,
        colorForSegmentAtIndex index: Int) -> UIColor {

        switch PieChartSegment(rawValue: index)! {
        case .Entertainment:
            return .orange
        case .Transportation:
            return .lightGray
        case .Food:
            return .blue
        case .Health:
            return .black
        case .Shopping:
            return .green
        }
    }

    func pieChartView(
        pieChartView: ORKPieChartView,
        titleForSegmentAtIndex index: Int) -> String {

        switch PieChartSegment(rawValue: index)! {
        case .Entertainment:
            return NSLocalizedString("Entertainment", comment: "")
        case .Transportation:
            return NSLocalizedString("Transportation", comment: "")
        case .Food:
            return NSLocalizedString("Food", comment: "")
        case .Health:
            return NSLocalizedString("Health", comment: "")
        case .Shopping:
            return NSLocalizedString("Shopping", comment: "")
        }

    }
    
    let graphChartView: ORKBarGraphChartView = {
        let bc = ORKBarGraphChartView()
        return bc
    }()
    
    
    let pieChartView: ORKPieChartView = {
        let pc = ORKPieChartView()
        return pc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupChannelCell()
        pieChartView.dataSource = self

//        pieChartView.title = "Budgeting Breakdown"
//        pieChartView.showsTitleAboveChart = true

        addSubview(pieChartView)
        pieChartView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 11, paddingLeft: 19, paddingBottom: 11, paddingRight: 0, width: 177, height: 0)
        
        pieChartView.lineWidth = 20
        
        pieChartView.animate(withDuration: 1)
        
        
        addSubview(textView)
        textView.anchor(top: pieChartView.topAnchor, left: pieChartView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -15, paddingLeft: 2, paddingBottom: 167, paddingRight: 4, width: 0, height: 0)
        
        
        
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

