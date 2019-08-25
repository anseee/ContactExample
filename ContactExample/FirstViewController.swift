//
//  FirstViewController.swift
//  ContactExample
//
//  Created by 박성원 on 25/08/2019.
//  Copyright © 2019 sungwon. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBAction func ContactViewMoveAction(_ sender: Any) {
        let viewController: ViewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        viewController.complation = {(contact: [String:String]) -> () in
            self.nameLabel.text = contact["name"]
            self.phoneNumberLabel.text = contact["phoneNumber"]
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

}
