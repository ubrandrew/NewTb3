//
//  MainHeader.swift
//  CapitalOneApp
//
//  Created by Niranjan Senthilkumar on 5/24/18.
//  Copyright © 2018 NJ. All rights reserved.
//

import UIKit
import TCProgressBar

class MainHeader: UICollectionViewCell {
    
    let progressBar = TCProgressBar(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 200,
                                                  height: 20))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        backgroundColor = UIColor.rgb(red: 245, green: 241, blue: 237)
        
        progressBar.outlineColor = .black
        progressBar.outlineWidth = 0.5
        progressBar.spacing = 5
        progressBar.progressColor = UIColor.rgb(red: 255, green: 51, blue: 102)
        progressBar.backgroundColor = .white
        progressBar.value = 0.2
        
        addSubview(progressBar)
        progressBar.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
