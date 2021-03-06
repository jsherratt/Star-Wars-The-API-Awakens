//
//  VehiclesViewController.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 15/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import UIKit

class VehiclesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    var vehiclesArray: [Vehicle]?
    var selectedVehicle: Vehicle? {
        didSet {
            self.updateLabelsForVehicle()
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
    
    //Text field
    @IBOutlet weak var exchangeTextField: UITextField!
    
    //-----------------------
    //MARK: View
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set delegate of exchange text field
        exchangeTextField.delegate = self
        
        //Add tap gesture recognizer to dissmiss keyboard when the view is tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        //Add notification observer for the showAlert function
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showAlert), name: "NetworkAlert", object: nil)
        
        //Navitgation bar
        self.navigationItem.title = "Vehicles"
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
        
        starWarsClient.fetchVehicles { result in
            
            switch result {
                
            case .Success(let vehicles):
                
                self.enableButtons()
                
                self.vehiclesArray = vehicles
                self.smallestLabel.text = self.starWarsClient.minMax(vehicles).smallest.name
                self.largestLabel.text = self.starWarsClient.minMax(vehicles).largest.name
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedVehicle = vehicles[self.pickerView.selectedRowInComponent(0)]
                self.pickerView.reloadAllComponents()
                
            case .Failure(let error as NSError):
                print(error.localizedDescription)
                
            default:
                break
            }
        }
    }
    
    //Update the labels when a new character is selected
    func updateLabelsForVehicle() {
        
        if let cost = selectedVehicle?.cost {
            costLabel.text = "\(cost) cr"
        }else {
            costLabel.text = "N/a"
        }
        
        if let length = selectedVehicle?.length {
            lengthLabel.text = "\(length.roundDecimal()) m"
        }else {
            lengthLabel.text = "N/a"
        }
        
        if let crew = selectedVehicle?.crew {
            crewLabel.text = "\(crew)"
        }else {
            crewLabel.text = "N/a"
        }
        
        makeLabel.text = selectedVehicle?.make
        classLabel.text = selectedVehicle?.vehicleClass
        
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
    
    //Dismiss the keyboard
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    //Show alert there is no network connection
    func showAlert() {
        
        displayAlert(title: "Error", message: "Check the network connection and try again")
    }
    
    //----------------------------
    //MARK: Picker View Delegate
    //----------------------------
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let vehicles = self.vehiclesArray {
            return vehicles.count
        }
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let vehicles = self.vehiclesArray {
            let vehicle = vehicles[row]
            return vehicle.name
        }
        
        return "Searching Galaxy Index"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let vehicles = self.vehiclesArray {
            let vehicle = vehicles[row]
            selectedVehicle = vehicle
        }
    }
    
    //----------------------------
    //MARK: Text Field Delegate
    //----------------------------
    
    //Reset button highlights when user begins editing the text field
    func textFieldDidBeginEditing(textField: UITextField) {
        
        usdButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        creditsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        //Reset button highlights
        usdButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        creditsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        //Set the cost label back to credits
        if let cost = selectedVehicle?.cost {
            
            costLabel.text = "\(cost) cr"
        }
        
        //Only allow number input to text fields that require numbers only
        let numberOnly = NSCharacterSet.init(charactersInString: "0123456789.")
        
        let stringFromTextField = NSCharacterSet.init(charactersInString: string)
        
        let stringValid = numberOnly.isSupersetOfSet(stringFromTextField)
        
        return stringValid
    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    
    //Set the cost to united states dollars form
    @IBAction func usdUnits(sender: UIButton) {
        
        usdButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        creditsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        
        if let cost = selectedVehicle?.cost {
            
            if let text = exchangeTextField.text {
                
                let numberFromText = Int(text)
                
                if numberFromText <= 0 {
                    
                    //Reset button highlights
                    usdButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
                    creditsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    
                    displayAlert(title: "Error", message: "You cannot enter 0 or a negative value for the exchange rate")
                    
                    
                }else {
                    costLabel.text = "\(cost * numberFromText!) usd"
                }
            }
        }
    }
    
    //Set the cost to star wars credits form
    @IBAction func creditUnits(sender: UIButton) {
        
        usdButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        creditsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        if let cost = selectedVehicle?.cost {
            
            costLabel.text = "\(cost) cr"
        }
    }
    
    //Set length to english (imperial) form
    @IBAction func englishUnits(sender: UIButton) {
        
        englishUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        metricUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        
        if let length = selectedVehicle?.length {
            
            lengthLabel.text = "\(length.englishUnits.roundDecimal()) ft"
        }
    }
    
    //Set length to metric form
    @IBAction func metricUnits(sender: UIButton) {
        
        englishUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        metricUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        if let length = selectedVehicle?.length {
            
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
    
    //Deinit the notification observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NetworkAlert", object: nil)
    }
    
    //-----------------------
    //MARK: Extra
    //-----------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
