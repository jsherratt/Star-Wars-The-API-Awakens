//
//  CharactersViewController.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 13/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //-----------------------
    //MARK: Variables
    //-----------------------
    
    //Buttons
    let backButton = UIImage(named: "backButton")
    
    //Break lines
    let topBarView = UIView()
    
    //Api client
    let starWarsClient = StarWarsClient()
    
    //Character variables
    var charactersArray: [Character]?
    var vehiclesArray: [String] = []
    var starshipsArray: [String] = []
    var selectedCharacter: Character? {
        didSet {
            self.updateLabelsForCharacter(selectedCharacter!)
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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    @IBOutlet weak var vehiclesLabel: UILabel!
    @IBOutlet weak var starshipsLabel: UILabel!
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var englishUnitsButton: UIButton!
    @IBOutlet weak var metricUnitsButton: UIButton!
    
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
        
        //Highlight metric button
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
        
        starWarsClient.fetchCharacters { result in
            
            switch result {
                
            case .Success(let characters):
                
                //Enable unit buttons
                self.enableButtons()
                
                self.charactersArray = characters
                self.smallestLabel.text = self.starWarsClient.minMax(characters).smallest.name
                self.largestLabel.text = self.starWarsClient.minMax(characters).largest.name
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedCharacter = characters[self.pickerView.selectedRowInComponent(0)]
                self.self.pickerView.reloadAllComponents()
                
            case .Failure(let error as NSError):
                print(error.localizedDescription)
                
            default:
                break
            }
        }
    }
    
    //Update the labels when a new character is selected
    func updateLabelsForCharacter(character: Character) {
        
        fetchVehiclesForCharacter(character)
        fetchStarshipsForCharacter(character)
        fetchHomeForCharacter(character)
        
        if let height = self.selectedCharacter?.height {
            self.heightLabel.text = "\(height)cm"
        }
        
        self.nameLabel.text = self.selectedCharacter?.name
        self.nameLabel.text = self.selectedCharacter?.name
        self.bornLabel.text = self.selectedCharacter?.birthyear
        self.eyeColorLabel.text = self.selectedCharacter?.eyeColor?.uppercaseFirst
        self.hairColorLabel.text = self.selectedCharacter?.hairColor?.uppercaseFirst
        
    }
    
    //Fetch the home of the character
    func fetchHomeForCharacter(character: Character) {
    
        self.starWarsClient.fetchHomeForCharacter(character) { result in
            
            switch result {
                
            case .Success(let home):
                
                self.englishUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
                self.metricUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                
                if let height = self.selectedCharacter?.height {
                    self.heightLabel.text = "\(height)cm"
                }
                
                self.homeLabel.text = home.name
                
            case .Failure(let error as NSError):
                print(error.localizedDescription)
                
            default:
                break
            }
        }
    }
    
    //Fetch the vehicle(s) for the character
    func fetchVehiclesForCharacter(character: Character) {
        
        if selectedCharacter?.vehiclesURL?.count > 0 {
            
            self.starWarsClient.fetchVehiclesForCharacter(character) { result in
                
                switch result {
                    
                case .Success(let vechicles):
                    
                    if vechicles.name != nil {
                        
                        self.vehiclesArray.append(vechicles.name!)
                        self.vehiclesLabel.text = "\(self.vehiclesArray.joinWithSeparator(", "))"
                    }
                    
                case .Failure(let error as NSError):
                    print(error)
                    
                default:
                    break
                }
            }
            
        }else {
            self.vehiclesLabel.text = "N/a"
        }
    }
    
    //Fetch the starship(s) for the character
    func fetchStarshipsForCharacter(character: Character) {
        
        if selectedCharacter?.starshipsURL?.count > 0 {
            
            self.starWarsClient.fetchStarshipsForCharacter(character) { result in
                
                switch result {
                    
                case .Success(let starships):
                    
                    if starships.name != nil {
                        
                        self.starshipsArray.append(starships.name!)
                        self.starshipsLabel.text = "\(self.starshipsArray.joinWithSeparator(", "))"
                    }
                    
                    //self.starshipsLabel.text = "\(self.starshipsArray)"
                    
                case .Failure(let error as NSError):
                    print(error)
                    
                default:
                    break
                }
            }
            
        }else {
            self.starshipsLabel.text = "N/a"
        }
    }
    
    //Enable the unit buttons
    func enableButtons() {
        
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
        
        if let characters = self.charactersArray {
            return characters.count
        }
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let characters = self.charactersArray {
            let character = characters[row]
            return character.name
        }
        
        return "Searching Galaxy Index"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        vehiclesArray.removeAll()
        starshipsArray.removeAll()
        
        if let characters = self.charactersArray {
            let character = characters[row]
            selectedCharacter = character
        }
    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    
    //Set height to english (imperial) form
    @IBAction func englishUnits(sender: UIButton) {
        
        englishUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        metricUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        
        if let height = selectedCharacter?.height {
            
            heightLabel.text = "\(height.englishUnits.roundDecimal())ft"
        }
    }
    
    //Set height to metric form
    @IBAction func metricUnits(sender: UIButton) {
        
        englishUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        metricUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        if let height = selectedCharacter?.height {
            
            heightLabel.text = "\(height)cm"
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























