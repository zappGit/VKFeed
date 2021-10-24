//
//  ViewController.swift
//  VKFeed
//
//  Created by Артем Хребтов on 21.10.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
    }
    @IBAction func signInButton(_ sender: UIButton) {
        authService.wakeUpSession()
    }
}

