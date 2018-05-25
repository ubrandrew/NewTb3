//
//  ViewController.swift
//  CapitalOneApp
//
//  Created by Niranjan Senthilkumar on 5/24/18.
//  Copyright © 2018 NJ. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UINavigationControllerDelegate {
    
    let logoImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "symbol"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.black.cgColor
        tf.autocorrectionType = .no
        tf.keyboardType = .emailAddress
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.autocapitalizationType = .none
        tf.font = UIFont(name: "Avenir-Light", size: 16)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.font = UIFont(name: "Avenir-Light", size: 16)
        //tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 &&  passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 51, blue: 102)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 93, blue: 133)
        }
    }

    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        //button.backgroundColor = UIColor.rgb(red: 255, green: 93, blue: 133)
        button.backgroundColor = UIColor.rgb(red: 255, green: 51, blue: 102)

        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        //button.isEnabled = false
        
        return button
    }()
    
    @objc func handleLogin(){
        guard let emailText = emailTextField.text else { return }
        guard let passText = passwordTextField.text else { return }
        
        if(emailText == "" && passText == ""){
            print("success")
            //let surveyController = DataViewController(collectionViewLayout: UICollectionViewFlowLayout())
            
            let surveyController = SurveyController()
            
            surveyController.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "capitalonelogo"))
            navigationController?.setNavigationBarHidden(false, animated: false)
            
            navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 245, green: 241, blue: 237)
            
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()

            
            navigationController?.pushViewController(surveyController, animated: true)
        }
        else{
            print("fail")
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 245, green: 241, blue: 237)
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 63, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
    }
    
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


