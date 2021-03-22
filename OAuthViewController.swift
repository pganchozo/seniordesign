//
//  OAuthViewController.swift
//  PerryThePenguin
//
//  Created by Elisabeth Garfield on 3/18/21.
//

import Foundation
import Auth0
import UIKit
import Lock

class OAuthViewController: UIViewController {

    @IBAction func login(_ sender: UIButton) {
    // HomeViewController.swift
    Lock
        .classic()
        // withConnections, withOptions, withStyle, and so on
        .withStyle{
            $0.title = ""
            $0.logo = UIImage(named: "penguinperry")
            $0.backgroundColor = UIColor.white
                                $0.headerColor = UIColor.white
                                $0.titleColor = UIColor.black
                                $0.secondaryButtonColor = UIColor.black
                                $0.buttonTintColor = UIColor.white
                                
                                $0.tabTextColor = UIColor.black
                                $0.tabTintColor = UIColor.black //UIColor.black
                                
                                $0.primaryColor = UIColor.black //(hex6: 0xED1D1D)
            
        }
        .withOptions {
          $0.oidcConformant = true
          $0.scope = "openid profile"
        }
        .onAuth { credentials in
          // Let's save our credentials.accessToken value
            guard credentials.accessToken != nil else { return }
                        
        }
        .present(from: self)
    
    


    }
}

