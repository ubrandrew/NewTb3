//
//  BotController.swift
//  CapitalOneApp
//
//  Created by Niranjan Senthilkumar on 5/25/18.
//  Copyright © 2018 NJ. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class BotController: UIViewController {

    let chipResponse: UILabel = {
        let chip = UILabel()
        chip.backgroundColor = .white
        chip.text = "Welcome to the OneBudget Bot! Ask me anything. Click the info button for help."
        chip.font = UIFont(name: "Avenir-Medium", size: 16)
        chip.numberOfLines = 0
        chip.textAlignment = .center
        chip.layer.borderWidth = 1
        chip.layer.cornerRadius = 10
        chip.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return chip
    }()
    
    let messageField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Message Chip"
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.black.cgColor
        tf.autocorrectionType = .no
        tf.keyboardType = .numbersAndPunctuation
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.font = UIFont(name: "Avenir-Light", size: 16)
        return tf
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        //button.backgroundColor = UIColor.rgb(red: 255, green: 93, blue: 133)
        button.backgroundColor = UIColor.rgb(red: 255, green: 51, blue: 102)
        
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        //button.isEnabled = false
        
        return button
    }()
    
    @objc func sendMessage(){
        let request = ApiAI.shared().textRequest()
        
        if let text = self.messageField.text, text != "" {
            request?.query = text
        } else {
            return
        }
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        messageField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 245, green: 241, blue: 237)
        view.addSubview(chipResponse)
        chipResponse.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 340, paddingRight: 10, width: 0, height: 0)
        
        view.addSubview(messageField)
        messageField.anchor(top: chipResponse.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 295, paddingRight: 10, width: 0, height: 0)
        
        view.addSubview(submitButton)
        submitButton.anchor(top: messageField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 225, height: 37)
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupNavBar()
    }
    
    func setupNavBar(){
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "info").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleInfo))
    }
    
    @objc func handleInfo(){
        let adVC = HelpController()
        
        self.present(adVC, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.chipResponse.text = text
        }, completion: nil)
    }
    
    
}
