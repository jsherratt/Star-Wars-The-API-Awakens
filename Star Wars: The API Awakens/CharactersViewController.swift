//
//  CharactersViewController.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 13/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController {
    
    //-----------------------
    //MARK: Variables
    //-----------------------
    let backButton = UIImage(named: "backBtn")
    let topBarView = UIView()
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    //-----------------------
    //MARK: View
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navitgation bar
        self.navigationItem.title = "Characters"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButton, style: .Plain, target: self, action: #selector(backToHome))
        
        //Top bar view
        topBarView.backgroundColor = UIColor(red: 21/255.0, green: 24/255.0, blue: 27/255.0, alpha: 1.0)
        view.addSubview(topBarView)
        setTopBarViewConstraints()
    }
    
    //-----------------------
    //MARK: Functions
    //-----------------------
    
    //Return to the home view
    func backToHome() {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //Setup the constraints for the break lines between the sections
    func setTopBarViewConstraints() {
        
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
            
            topBarView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            topBarView.bottomAnchor.constraintEqualToAnchor(infoView.topAnchor),
            topBarView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            topBarView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            
            ])
    }
    
    //-----------------------
    //MARK: Extra
    //-----------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
