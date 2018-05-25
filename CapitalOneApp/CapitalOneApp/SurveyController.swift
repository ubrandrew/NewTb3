//
//  SurveyController.swift
//  CapitalOneApp
//
//  Created by Niranjan Senthilkumar on 5/24/18.
//  Copyright © 2018 NJ. All rights reserved.
//

import UIKit

class SurveyController: UIViewController {
    
    let textView: UILabel = {
        let tv = UILabel()
        tv.text = "If you save 20% on\nyour monthly\nincome, you'll get\n2% back."
        tv.numberOfLines = 0
        tv.textAlignment = .center
        tv.adjustsFontSizeToFitWidth = true
        //tv.text = tv.text?.components(separatedBy: .newLines)
        tv.font = UIFont(name: "Avenir-Heavy", size: 28)
        return tv
    }()
    
    let declarationView: UILabel = {
        let tv = UILabel()
        tv.text = "Enter your monthly income."
        tv.numberOfLines = 0
        tv.textAlignment = .center
        tv.adjustsFontSizeToFitWidth = true
        //tv.text = tv.text?.components(separatedBy: .newLines)
        tv.font = UIFont(name: "Avenir-Medium", size: 20)
        return tv
    }()
    
    let incomeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Monthly Income"
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.black.cgColor
        tf.autocorrectionType = .no
        tf.keyboardType = .numberPad
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.autocapitalizationType = .none
        tf.font = UIFont(name: "Avenir-Light", size: 16)
        tf.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        return tf
    }()
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 255, green: 51, blue: 102)
        
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        //button.isEnabled = false
        
        return button
    }()
    
    @objc func handleSubmit(){
        let mainNavController = MainNavController()
        
        mainNavController.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "capitalonelogo"))
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 245, green: 241, blue: 237)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.pushViewController(mainNavController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 245, green: 241, blue: 237)
        
        view.addSubview(textView)
        textView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 333, height: 260)
        
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(declarationView)
        declarationView.anchor(top: textView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        declarationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
        setupNavBar()

    }
    
    func setupNavBar(){
        self.navigationController?.navigationBar.topItem?.title = " "
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hack").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNothing))
    }
    
    @objc func handleNothing(){
        print(123)
    }
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [incomeTextField, submitButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: declarationView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 100)
        
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
