//
//  HomeViewController.swift
//  T.M.Y.S-Thennakoon-COBSCCOMP181P015
//
//  Created by MacBook Air on 11/21/19.
//  Copyright © 2019 NIBM. All rights reserved.
//

import UIKit
import BiometricAuthentication

class HomeViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: ProfileViewController.self) {
            
            //call biometric authentcation library
            BioMetricAuthenticator.authenticateWithBioMetrics(reason: "Identify User") { (result) in
                
                switch result {
                case .success( _):
                    print("Access Granted!")
                    self.selectedIndex = 2
                case .failure(let error):
                    print("Access Denied!")
                    
                }
            }
            return false
        }
        return true
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
