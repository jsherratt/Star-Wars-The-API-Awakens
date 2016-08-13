//
//  CharactersViewController.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 13/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController {
    
    let backButton = UIImage(named: "backBtn")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Characters"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButton, style: .Plain, target: self, action: #selector(backToHome))
    }
    
    func backToHome() {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
