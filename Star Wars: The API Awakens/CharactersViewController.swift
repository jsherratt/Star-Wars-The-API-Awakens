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
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
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
        
        setupPickerView()
    }
    
    func setupPickerView() {
        
        starWarsClient.fetchCharacters { result in
            
            switch result {
                
            case .Success(let characters):
                
                self.charactersArray = characters
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                self.selectedCharacter = characters[self.pickerView.selectedRowInComponent(0)]
                self.self.pickerView.reloadAllComponents()
                
                print(self.charactersArray)
                
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
        
        starWarsClient.fetchCharacter(character) { result in
            
            switch result {
                
            case .Success(let character):
                
                print(character)
                
                if let height = character.height {
                    self.heightLabel.text = "\(height)m"
                }
                
                self.nameLabel.text = character.name
                self.bornLabel.text = character.birthyear
                self.homeLabel.text = "NA"
                //self.heightLabel.text = "\(character.height)"
                self.eyeColorLabel.text = character.eyeColor
                self.hairColorLabel.text = character.hairColor
                
            case .Failure(let error as NSError):
                print(error.localizedDescription)
                
            default:
                break
            }
        }
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
    //MARK: Extra
    //-----------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}























