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
    let backButton = UIImage(named: "backButton")
    let topBarView = UIView()
    
    let starWarsClient = StarWarsClient()
    var charactersArray: [Character]?
    var selectedCharacter: Character? {
        
        didSet {
            self.updateLabelsForCharacter(selectedCharacter!)
        }
    }
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    
    //Views
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
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
        
        setupPickerView()
    }
    
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
    
    func updateLabelsForCharacter(character: Character) {
        
        //Fetch the data for the selected character
        starWarsClient.fetchCharacter(character: character) { result in
            
            switch result {
                
            case .Success(let character):
                
                //Fetch the home of the character
                self.starWarsClient.fetchHomeForCharacter(character) { result in
                    
                    switch result {
                        
                    case .Success(let home):
                        
                        self.englishUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
                        self.metricUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                        
                        if let height = character.height {
                            self.heightLabel.text = "\(height)cm"
                        }
                        
                        self.nameLabel.text = character.name
                        self.bornLabel.text = character.birthyear
                        self.homeLabel.text = home.name
                        self.eyeColorLabel.text = character.eyeColor?.uppercaseFirst
                        self.hairColorLabel.text = character.hairColor?.uppercaseFirst
                        
                    case .Failure(let error as NSError):
                        print(error.localizedDescription)
                        
                    default:
                        break
                    }
                }
                
            case .Failure(let error as NSError):
                print(error.localizedDescription)
                
            default:
                break
            }
        }
    }
    
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
        
        if let characters = self.charactersArray {
            let character = characters[row]
            selectedCharacter = character
        }
    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    @IBAction func englishUnits(sender: UIButton) {
        
        englishUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        metricUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        
        if let height = selectedCharacter?.height {
            
            heightLabel.text = "\(height.englishUnits.roundDecimal())ft"
        }
    }
    
    @IBAction func metricUnits(sender: UIButton) {
        
        englishUnitsButton.setTitleColor(UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0), forState: .Normal)
        metricUnitsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        if let height = selectedCharacter?.height {
            
            heightLabel.text = "\(height)cm"
        }
    }
    
    //-----------------------
    //MARK: Extra
    //-----------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}























