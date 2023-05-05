//
//  DetailsViewController.swift
//  ScrollViewAndProtocol
//
//  Created by Talor Levy on 2/21/23.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: - @IBOutlet
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var middleNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var delegate: SendEditAgain?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let user = UserViewModel.shared.user ?? UserModel()
        delegate?.sendEditAgain(user: user)
    }
    
    func configureLabels() {
        let user = UserViewModel.shared.user
        firstNameLabel.text = "First Name: \(user?.firstName ?? "")"
        middleNameLabel.text = "Middle Name: \(user?.middleName ?? "")"
        lastNameLabel.text = "Last Name: \(user?.lastName ?? "")"
        ageLabel.text = "Age: \(String(user?.age ?? 0))"
        switch user?.gender {
        case .male:
            genderLabel.text = "Gender: Male"
        case .female:
            genderLabel.text = "Gender: Female"
        default:
            genderLabel.text = ""
        }
        emailLabel.text = "Email: \(user?.email ?? "")"
        phoneNumberLabel.text = "Phone Number: \(user?.phoneNumber ?? "")"
        dateOfBirthLabel.text = "Date Of Birth: \(formatDateToString(user?.dateOfBirth ?? Date()))"
        cityLabel.text = "City: \(user?.city ?? "")"
        stateLabel.text = "State: \(user?.state ?? "")"
        countryLabel.text = "Country: \(user?.country ?? "")"
        usernameLabel.text = "Username: \(user?.username ?? "")"
    }
    
    // MARK: - Formatting

    func createFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }
    
    func formatDateToString(_ date: Date) -> String {
        let dateFormatter = createFormatter()
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    // MARK: - @IBOutlet

    @IBAction func editButtonAction(_ sender: Any) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController else { return }
        editVC.delegate = self
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}


// MARK: - SendEdit

extension DetailsViewController: SendEdit {
    func sendEdit(user: UserModel) {
        firstNameLabel.text = "First Name: \(user.firstName ?? "")"
        middleNameLabel.text = "Middle Name: \(user.middleName ?? "")"
        lastNameLabel.text = "Last Name: \(user.lastName ?? "")"
        ageLabel.text = "Age: \(String(user.age ?? 0))"
        switch user.gender {
        case .male:
            genderLabel.text = "Gender: Male"
        case .female:
            genderLabel.text = "Gender: Female"
        default:
            genderLabel.text = ""
        }
        emailLabel.text = "Email: \(user.email ?? "")"
        phoneNumberLabel.text = "Phone Number: \(user.phoneNumber ?? "")"
        dateOfBirthLabel.text = "Date Of Birth: \(formatDateToString(user.dateOfBirth ?? Date()))"
        cityLabel.text = "City: \(user.city ?? "")"
        stateLabel.text = "State: \(user.state ?? "")"
        countryLabel.text = "Country: \(user.country ?? "")"
        usernameLabel.text = "Username: \(user.username ?? "")"
    }
}


// MARK: - SendEditAgain

protocol SendEditAgain {
    func sendEditAgain(user: UserModel)
}
