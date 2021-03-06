//
//  ViewController.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 13/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //-----------------------
    //MARK: Variables
    //-----------------------
    
    //Views
    var characterBreakLine = UIView()
    var vehicleBreakLine = UIView()
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    @IBOutlet weak var characterStackView: UIStackView!
    @IBOutlet weak var vehicleStackView: UIStackView!
    
    lazy var starWarsClient = StarWarsClient()
    
    //-----------------------
    //MARK: Views
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cutomise navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0), NSFontAttributeName:UIFont.boldSystemFontOfSize(21.0)]
        
        //Add two break lines to the view to separate the selections
        characterBreakLine.backgroundColor = UIColor(red: 56/255.0, green: 57/255.0, blue: 59/255.0, alpha: 0.5)
        view.addSubview(characterBreakLine)
        
        vehicleBreakLine.backgroundColor = UIColor(red: 56/255.0, green: 57/255.0, blue: 59/255.0, alpha: 0.5)
        view.addSubview(vehicleBreakLine)
        
        //Setup constraints
        setupBreakLineConstraints()
    }
    
    //-----------------------
    //MARK: Constraints
    //-----------------------
    
    //Setup the constraints for the break lines between the sections
    func setupBreakLineConstraints() {
        
        characterBreakLine.translatesAutoresizingMaskIntoConstraints = false
        vehicleBreakLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
            
            characterBreakLine.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            characterBreakLine.heightAnchor.constraintEqualToConstant(1.5),
            characterBreakLine.topAnchor.constraintEqualToAnchor(characterStackView.bottomAnchor, constant: 10),
            characterBreakLine.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 35),
            characterBreakLine.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -35),
            
            vehicleBreakLine.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            vehicleBreakLine.heightAnchor.constraintEqualToConstant(1.5),
            vehicleBreakLine.topAnchor.constraintEqualToAnchor(vehicleStackView.bottomAnchor, constant: 10),
            vehicleBreakLine.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 35),
            vehicleBreakLine.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -35)
            
            ])
    }

    //-----------------------
    //MARK: Extra
    //-----------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
