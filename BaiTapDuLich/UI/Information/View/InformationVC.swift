//
//  InformationVC.swift
//  TestThuDelegate
//
//  Created by Admin on 27/6/25.
//

import UIKit
protocol InformationDelegate: AnyObject{
    func didAddUserProfile(_ userProfile: UserProfile)
}
protocol InformationUpdateDelegate: AnyObject{
    func didUpdateUser(_ user: UserProfile)
}
class InformationVC: UIViewController {
    
    @IBOutlet weak var heightV: LabelTextFieldV!
    @IBOutlet weak var weightV: LabelTextFieldV!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var lastNameV: LabelTextFieldV!
    @IBOutlet weak var firstNameV: LabelTextFieldV!
    
    private var hasUser: Bool?
    var mode: FormMode = .add
    var userProfile: UserProfile?
    weak var informationDelegate: InformationDelegate?
    weak var informationUpdateDelegate: InformationUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Information"
        heightV.config(label: "Height", textField: "Enter height...")
        weightV.config(label: "Weight", textField: "Enter weight...")
        firstNameV.config(label: "First name", textField: "Enter first name...")
        lastNameV.config(label: "Last name", textField: "Enter last name...")
        button.layer.cornerRadius = 16

        if(mode == .update){
            button.titleLabel?.text = "Update"
            if let userProfile{
                firstNameV.setTextField(text: userProfile.firstName)
                lastNameV.setTextField(text: userProfile.lastName)
                heightV.setTextField(text: String(Int(userProfile.height)))
                weightV.setTextField(text: String(Int(userProfile.weight)))
                            
                for i in 0..<gender.numberOfSegments{
                    if(gender.titleForSegment(at: i)?.lowercased() == userProfile.getGender().lowercased()){
                            gender.selectedSegmentIndex = i
                            break
                    }
                }
            }
        }
        if(mode == .add){
            validateInput()
            for textField in [firstNameV.getTextField(), lastNameV.getTextField(), heightV.getTextField(), weightV.getTextField()]{
                textField.addTarget(self, action: #selector(textFieldChanged), for:.editingChanged)
            }
            gender.addTarget(self, action: #selector(textFieldChanged), for: .valueChanged)
        } else {
            validateInputUpdate()
            for textField in [firstNameV.getTextField(), lastNameV.getTextField(), heightV.getTextField(), weightV.getTextField()]{
                textField.addTarget(self, action: #selector(textFieldUpdate), for:.editingChanged)
            }
            gender.addTarget(self, action: #selector(textFieldUpdate), for: .valueChanged)
        }
    }
    
    @IBAction func btn(_ sender: Any) {
        if(mode == .add){
            let firstName = firstNameV.getTextField().text ?? ""
            let lastName = lastNameV.getTextField().text ?? ""
            let weight = weightV.getTextField().text ?? "0"
            let height = heightV.getTextField().text ?? "0"
            
            let genderIndexPath = gender.selectedSegmentIndex
            let genderString = gender.titleForSegment(at: genderIndexPath)?.lowercased() ?? ""
            let selectedGender = Gender(rawValue: genderString)
            let userProfile = UserProfile(firstName: firstName, lastName: lastName, weight: Double(weight) ?? 0, height: Double(height) ?? 0, gender: selectedGender ?? .male)
            if(button.backgroundColor != .neutral3){
                let vc = ProfileVC()
                vc.userProfile = userProfile
                vc.profileDelegate = self
                navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let userProfile = self.userProfile
            userProfile?.firstName = firstNameV.getTextField().text ?? ""
            userProfile?.lastName = lastNameV.getTextField().text ?? ""
            if let heightValue = heightV.getTextField().text,
               let weightValue = weightV.getTextField().text{
                if let heightValueDouble = Double(heightValue),
                   let weightValueDouble = Double(weightValue){
                    userProfile?.height = heightValueDouble
                    userProfile?.weight = weightValueDouble
                }else{
                    return
                }
            }
            let genderString: String = gender.titleForSegment(at: gender.selectedSegmentIndex) ?? ""
            if let selectedGender = Gender(rawValue: genderString.lowercased()) {
                userProfile?.gender = selectedGender
            }
            if let userProfile = userProfile{
                if userProfile.height != 0 && userProfile.weight != 0
                    && userProfile.height < 300 && userProfile.weight < 1000{
                    informationUpdateDelegate?.didUpdateUser(userProfile)
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    private func validateInput(){
        let firstName = firstNameV.getTextField().text ?? ""
        let lastName = lastNameV.getTextField().text ?? ""
        let height = heightV.getTextField().text ?? ""
        let weight = weightV.getTextField().text ?? ""
        let genderIndex = gender.selectedSegmentIndex
        let genderTitle = gender.titleForSegment(at: genderIndex) ?? ""
        if let heightInt = (Int(height)),
           let weightInt = Int(weight){
            if(!firstName.isEmpty && !lastName.isEmpty && !height.isEmpty &&
               !weight.isEmpty && !genderTitle.isEmpty && heightInt < 300 && weightInt < 1000){
                button.backgroundColor = .primary
            }else{
                button.backgroundColor = .neutral3
            }
        }
        else{
            button.backgroundColor = .neutral3
        }
    }
    
    func validateInputUpdate(){
        let firstName = firstNameV.getTextField().text ?? ""
        let lastName = lastNameV.getTextField().text ?? ""
        let height = heightV.getTextField().text ?? ""
        let weight = weightV.getTextField().text ?? ""
        let genderIndex = gender.selectedSegmentIndex
        let genderTitle = gender.titleForSegment(at: genderIndex) ?? ""
        guard let genderUser = userProfile?.gender.rawValue else{
            return
        }
        print("\(genderUser) \(genderTitle)")
        if(firstName != userProfile?.firstName || lastName != userProfile?.lastName
           || height != String(userProfile?.height ?? 0)
           ||  weight != String(userProfile?.weight ?? 0)
           || genderTitle != genderUser
        ){
            if let heighInt = (Int(height)),
               let weightInt = Int(weight){
                if(heighInt < 300 && weightInt < 1000){
                    button.backgroundColor = .primary
                }
            }
        }else{
            button.backgroundColor = .neutral3
        }
    }
    
    @objc func textFieldChanged(_ sender: Any){
        validateInput()
    }
    @objc func textFieldUpdate(_ sender: Any){
        validateInputUpdate()
    }
    @objc func didTapBackForBtn(){
        navigationController?.popViewController(animated: true)
    }
    
}
extension InformationVC: ProfileDelegate{
    func getUpdateProfile(_ userProfile: UserProfile) {
        //        self.userProfile = userProfile
        self.informationUpdateDelegate?.didUpdateUser(userProfile)
    }
}
