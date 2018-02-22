//
//  ViewController.swift
//  RxSwiftLoginView
//
//  Created by Navdeep on 27/9/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var validationsLabel: UILabel!
    
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.lightGray
        
        
        //Bind UI textFields to properties in ViewModel
        
        _ = usernameTextField.rx.text.map { $0 ?? "" }
        .bind(to: loginViewModel.username)
        _ = passwordTextField.rx.text.map {$0 ?? "" }
        .bind(to: loginViewModel.password)
        
        _ = loginViewModel.isValid.bind(to: loginButton.rx.isEnabled)
        
        _ = loginViewModel.isValid.subscribe(onNext: {[unowned self] isValid in
        
            self.validationsLabel.text = isValid ? "Enabled" : "Disabled"
            self.validationsLabel.textColor = isValid ? .green : .red
            
            //Log the values with each key in event
            print(isValid)
            
            //Making changes to the login button
            self.loginButton.isEnabled = isValid ? true : false
            self.loginButton.backgroundColor = isValid ? UIColor.orange : UIColor.lightGray
        })
        
    }

}

