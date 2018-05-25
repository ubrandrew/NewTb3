//
//  MainNavController.swift
//  CapitalOneApp
//
//  Created by Niranjan Senthilkumar on 5/24/18.
//  Copyright © 2018 NJ. All rights reserved.
//

import UIKit

class MainNavController: UIViewController {
    
    let dataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Data Visuals", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 0, green: 71, blue: 123)
        
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 24)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleDataPress), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleDataPress(){
        let dataController = DataViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        dataController.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "capitalonelogo"))
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 245, green: 241, blue: 237)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.pushViewController(dataController, animated: true)
    }
    
    let botButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chatbot", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 255, green: 51, blue: 102)
        
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 24)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleBotPress), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleBotPress(){
        print(43)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 245, green: 241, blue: 237)
        
        //self.navigationItem.leftBarButtonItem = nil
        
        navigationController?.navigationItem.leftBarButtonItem = nil
        
        self.navigationController?.navigationBar.topItem?.title = " "
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hack").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNothing))
        
        setupInputFields()

    }
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [dataButton, botButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 13
        
        view.addSubview(stackView)
        
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 19, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 141)
        
    }
    
    @objc func handleNothing(){
        print(123)
    }
}
