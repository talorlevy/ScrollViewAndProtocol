//
//  EditViewController.swift
//  ScrollViewAndProtocol
//
//  Created by Talor Levy on 2/21/23.
//

import UIKit

class EditViewController: UIViewController {

    // MARK: - @IBOutlet
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var delegate: SendEdit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    
    func configureTextFields() {
        let user = UserViewModel.shared.user
        firstNameTextField.text = user?.firstName
        middleNameTextField.text = user?.middleName
        lastNameTextField.text = user?.lastName
        ageTextField.text = String(user?.age ?? 0)
        switch user?.gender {
        case .male:
            genderTextField.text = "Male"
        case .female:
            genderTextField.text = "Female"
        default:
            genderTextField.text = ""
        }
        emailTextField.text = user?.email
        phoneNumberTextField.text = user?.phoneNumber
        dateOfBirthTextField.text = formatDateToString(user?.dateOfBirth ?? Date())
        cityTextField.text = user?.city
        stateTextField.text = user?.state
        countryTextField.text = user?.country
        usernameTextField.text = user?.username
    }
    
    // MARK: - Formatting

    func createDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }
    
    func formatDateToString(_ date: Date) -> String {
        let dateFormatter = createDateFormatter()
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func formatNameOrPlace(_ inputString: String) -> String {
        guard !inputString.isEmpty else { return inputString }
        let firstLetter = String(inputString.prefix(1).capitalized)
        let remainingLetters = String(inputString.dropFirst().lowercased())
        return firstLetter + remainingLetters
    }
    
    func formatCountry(_ inputString: String) -> String {
        if (inputString.uppercased() == "USA") {
            return "USA"
        } else {
            guard !inputString.isEmpty else { return inputString }
            let firstLetter = String(inputString.prefix(1).capitalized)
            let remainingLetters = String(inputString.dropFirst().lowercased())
            return firstLetter + remainingLetters
        }
    }
    
    // MARK: - Validation

    func validateAllFieldsCompleted() -> Bool {
        if (firstNameTextField.text == "" || middleNameTextField.text == "" || lastNameTextField.text == "" ||
            ageTextField.text == "" || genderTextField.text == "" || emailTextField.text == "" ||
            phoneNumberTextField.text == "" || dateOfBirthTextField.text == "" || cityTextField.text == "" ||
            stateTextField.text == "" || countryTextField.text == "") {
            let alertController = UIAlertController(title: "Warning", message: "You must fill in all fields!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    func validateAge(_ strAge: String) -> Bool {
        guard let age = Int(strAge) else {
            let alertController = UIAlertController(title: "Warning", message: "Must enter age as a number greater than 0!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return false
        }
        if age <= 0 {
            let alertController = UIAlertController(title: "Warning", message: "Must enter age as a number greater than 0!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateGender(_ gender: Any) -> Bool {
        if (genderTextField.text?.lowercased() != "male" && genderTextField.text?.lowercased() != "female") {
            let alertController = UIAlertController(title: "Warning", message: "Must enter 'male' or 'female' for gender!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = email.range(of: emailPattern, options: .regularExpression)
        if result == nil {
            let alertController = UIAlertController(title: "Warning", message: "Invalid email!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !predicate.evaluate(with: phoneNumber) {
            let alertController = UIAlertController(title: "Warning", message: "Must enter phone number with the format as xxx-xxx-xxxx!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    func validateDateOfBirth() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let _ = dateFormatter.date(from: dateOfBirthTextField.text ?? "") {
            return true
        } else {
            let alertController = UIAlertController(title: "Warning", message: "Must enter date as dd-MM-yyyy!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    func validateUsername() -> Bool {
        let usernamePattern = #"^[a-zA-Z-]+ ?.* [a-zA-Z-]+$"#
        let username = usernameTextField.text ?? ""
        let result = username.range(of: usernamePattern, options: .regularExpression)
        if result == nil {
            let alertController = UIAlertController(title: "Warning", message: "Invalid username!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    // MARK: - @IBAction
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if let delegate = delegate {
            if !validateAllFieldsCompleted() { return }
            
            let firstName = formatNameOrPlace(firstNameTextField.text ?? "")
            let middleName = formatNameOrPlace(middleNameTextField.text ?? "")
            let lastName = formatNameOrPlace(lastNameTextField.text ?? "")
            
            if !validateAge(ageTextField.text ?? "") { return }
            let age = Int(ageTextField.text ?? "")
            
            if !validateGender(genderTextField.text ?? "") { return }
            let gender = GenderEnum.Gender(rawValue: genderTextField.text?.lowercased() ?? "")
            
            let email = emailTextField.text ?? ""
            if !validateEmail(email) { return }
            
            let phoneNumber = phoneNumberTextField.text ?? ""
            if !validatePhoneNumber(phoneNumber) { return }
            
            if !validateDateOfBirth() { return }
            let dateFormatter = createDateFormatter()
            let dateOfBirth = dateFormatter.date(from: dateOfBirthTextField.text ?? "")
            
            let city = formatNameOrPlace(cityTextField.text ?? "")
            let state = formatNameOrPlace(stateTextField.text ?? "")
            let country = formatCountry(countryTextField.text ?? "")
            
            if !validateUsername() { return }
            let username = usernameTextField.text ?? ""
            
            let user = UserModel(firstName: firstName, middleName: middleName, lastName: lastName,
                                 age: age, gender: gender, email: email, phoneNumber: phoneNumber,
                                 dateOfBirth: dateOfBirth, city: city, state: state, country: country,
                                 username: username)
            delegate.sendEdit(user: user)
            UserViewModel.shared.user = user
        }
        self.navigationController?.popViewController(animated: true)
    }
}

protocol SendEdit {
    func sendEdit(user: UserModel)
}
