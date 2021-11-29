//
//  AuthService.swift
//  VKFeed
//
//  Created by Артем Хребтов on 21.10.2021.
//

import Foundation
import VKSdkFramework

protocol AuthServiseDelegate: AnyObject {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFail()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    
    private let appId = "7981400"
    private let vkSdk: VKSdk
    
    var userId: String? {
        return VKSdk.accessToken().userId
    }
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("Vksdk")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    weak var delegate: AuthServiseDelegate?
    var token: String? {
        return VKSdk.accessToken().accessToken
    }

    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
        delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSignInDidFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    func wakeUpSession() {
        let scope = ["wall,friends"]
        VKSdk.wakeUpSession(scope) { [delegate] state, error in
            switch state {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                delegate?.authServiceSignIn()
            default:
                delegate?.authServiceSignInDidFail()
            }
        }
    }
}
