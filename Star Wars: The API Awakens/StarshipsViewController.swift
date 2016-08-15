//
//  StarshipsViewController.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 15/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import UIKit

class StarshipsViewController: UIViewController {

    //-----------------------
    //MARK: Variables
    //-----------------------
    
    //Buttons
    let backButton = UIImage(named: "backButton")
    
    //Break lines
    let topBarView = UIView()
    
    //Api client
    let starWarsClient = StarWarsClient()
    
    //Vehicle variables
    var starshipsArray: [Starship]?
    var selectedStarship: Starship? {
        didSet {
            self.updateLabelsForStarship()
        }
    }
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    
    //Views
    @IBOutlet weak var infoViewStackView: UIStackView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //Labels
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var englishUnitsButton: UIButton!
    @IBOutlet weak var metricUnitsButton: UIButton!
    
    //-----------------------
    //MARK: View
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navitgation bar
        self.navigationItem.title = "Starships"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButton, style: .Plain, target: self, action: #selector(backToHome))
        
        //Top bar view
        topBarView.backgroundColor = UIColor(red: 21/255.0, green: 24/255.0, blue: 27/255.0, alpha: 1.0)
        view.addSubview(topBarView)
        setTopBarViewConstraints()
        
        //Highlight metric and credit buttons
        usdButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        creditsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        englishUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        metricUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        //Setup and populate the picker view
        setupPickerView()
    }
    
    //-----------------------
    //MARK: Functions
    //-----------------------
    
    //Return to the home view
    func backToHome() {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //Setup and populate the picker view
    func setupPickerView() {
        
        starWarsClient.fetchStarships { result in
            
            switch result {
                
            case .Success(let starships):
                
                self.enableButtons()
                
                self.starshipsArray = starships
                self.smallestLabel.text = self.starWarsClient.minMax(starships).smallest.name
                self.largestLabel.text = self.starWarsClient.minMax(starships).largest.name
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedStarship = starships[self.pickerView.selectedRowInComponent(0)]
                self.pickerView.reloadAllComponents()
                
            case .Failure(let error as NSError):
                print(error.localizedDescription)
                
            default:
                break
            }
        }
    }
    
    //Update the labels when a new character is selected
    func updateLabelsForStarship() {
        
        if let cost = selectedStarship?.cost {
            costLabel.text = "\(cost) cr"
        }
        
        if let length = selectedStarship?.length {
            lengthLabel.text = "\(length.roundDecimal()) m"
        }
        
        if let crew = selectedStarship?.crew {
            crewLabel.text = "\(crew)"
        }
        
        makeLabel.text = selectedStarship?.make
        classLabel.text = selectedStarship?.starshipClass
        
        self.usdButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        self.creditsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.englishUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        self.metricUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    //Enable the unit buttons
    func enableButtons() {
        
        usdButton.enabled = true
        creditsButton.enabled = true
        englishUnitsButton.enabled = true
        metricUnitsButton.enabled = true
    }
    
    //----------------------------
    //MARK: Picker View Delegate
    //----------------------------
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let starships = self.starshipsArray {
            return starships.count
        }
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let starships = self.starshipsArray {
            let starship = starships[row]
            return starship.name
        }
        
        return "Searching Galaxy Index"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let starships = self.starshipsArray {
            let starship = starships[row]
            selectedStarship = starship
        }
    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    
    //Set the cost to united states dollars form
    @IBAction func usdUnits(sender: UIButton) {
        
        usdButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        creditsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        
        if let cost = selectedStarship?.cost {
            
            costLabel.text = "\(cost.usdUnits) usd"
        }
    }
    
    //Set the cost to star wars credits form
    @IBAction func creditUnits(sender: UIButton) {
        
        usdButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        creditsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        if let cost = selectedStarship?.cost {
            
            costLabel.text = "\(cost) cr"
        }
    }
    
    //Set length to english (imperial) form
    @IBAction func englishUnits(sender: UIButton) {
        
        englishUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        metricUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        
        if let length = selectedStarship?.length {
            
            lengthLabel.text = "\(length.englishUnits.roundDecimal()) ft"
        }
    }
    
    //Set length to metric form
    @IBAction func metricUnits(sender: UIButton) {
        
        englishUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        metricUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        if let length = selectedStarship?.length {
            
            lengthLabel.text = "\(length.roundDecimal()) m"
        }
    }
    
    //-----------------------
    //MARK: Constraints
    //-----------------------
    
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
