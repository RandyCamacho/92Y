//
//  CompleteProfileViewController.swift
//  app-92Y
//
//  Created by Randy Camacho on 11/15/20.
//

import UIKit
import  FirebaseAuth

class CompleteProfileViewController: UIViewController {
    var firstname: String = ""
    var lastname: String = ""
    var email: String = ""
    var password: String = ""
    
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let rankField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Rank..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let uicField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Unit Identification Code..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let jobtitleField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Job Title..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let pictureTitle: UILabel = {
       let label = UILabel()
        label.text = "Add a Profile Picture"
        return label
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(pictureTitle)
        scrollView.addSubview(imageView)
        scrollView.addSubview(rankField)
        scrollView.addSubview(uicField)
        scrollView.addSubview(jobtitleField)
        scrollView.addSubview(signupButton)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        pictureTitle.frame = CGRect(x: scrollView.width/3, y: 20, width: scrollView.width-60, height: 52)
        imageView.frame = CGRect(x: scrollView.width/3, y: pictureTitle.bottom+10, width: scrollView.width/3, height: scrollView.width/3)
        rankField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        uicField.frame = CGRect(x: 30, y: rankField.bottom+10, width: scrollView.width-60, height: 52)
        jobtitleField.frame = CGRect(x: 30, y: uicField.bottom+10, width: scrollView.width-60, height: 52)
        signupButton.frame = CGRect(x: 30, y: jobtitleField.bottom+10, width: scrollView.width-60, height: 52)
    }
    
    @objc private func signup() {
        uicField.resignFirstResponder()
        rankField.resignFirstResponder()
        jobtitleField.resignFirstResponder()
        
        guard let rank = rankField.text, let uic = uicField.text, let jobtitle = jobtitleField.text, !rank.isEmpty, !uic.isEmpty, !jobtitle.isEmpty else {
            alertUserSignUpError()
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {authResult, error in guard let result = authResult, error == nil else {
            print("Error in createing user")
            return
        }
        
        let user = result.user
        print("Created User: \(user.email)")
        })
        
    }
    
    func alertUserSignUpError() {
        let alert = UIAlertController(title: "Woops", message: "Could Not Create Account \nAll Fields must be filled", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
extension CompleteProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == rankField {
            uicField.becomeFirstResponder()
        } else if textField == uicField {
            jobtitleField.becomeFirstResponder()
        } else if textField == jobtitleField {
            signup()
        }
        return true
    }
}
