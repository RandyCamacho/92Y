//
//  CompleteProfileViewController.swift
//  app-92Y
//
//  Created by Randy Camacho on 11/15/20.
//

import UIKit
import  FirebaseAuth
import DropDown

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
    
    private let menu: DropDown = {
       let menu = DropDown()
        menu.dataSource = [
        "Private", "Private First Class", "Specialist", "Corporal", "Sergeant", "Staff Sergeant","Sergeant First Class", "Master Sergeant", "First Sergeant", "Sergeant Major", "Command Sergeant Major", "Sergeant Major of the Army"
            
        ]
        return menu
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
    
    private let rankButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Rank", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
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
        button.backgroundColor = .systemGreen
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
        rankButton.addTarget(self, action: #selector(chooseRank), for: .touchUpInside)
        menu.anchorView = rankButton
        menu.selectionAction = {index, title in
           let rank = title
            print("Rank: \(rank)")
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(pictureTitle)
        scrollView.addSubview(imageView)
        scrollView.addSubview(rankButton)
        scrollView.addSubview(uicField)
        scrollView.addSubview(jobtitleField)
        scrollView.addSubview(signupButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePic))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gesture)

    }
    
    @objc private func changeProfilePic() {
        print("Change Pic")
        presentPhotoActionSheet()
    }
    @objc private func chooseRank(){
        menu.show()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        pictureTitle.frame = CGRect(x: scrollView.width/3.2, y: 20, width: scrollView.width-60, height: 52)
        imageView.frame = CGRect(x: scrollView.width/3, y: pictureTitle.bottom+5, width: scrollView.width/3, height: scrollView.width/3)
        imageView.layer.cornerRadius = imageView.width/2.0
        rankButton.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        uicField.frame = CGRect(x: 30, y: rankButton.bottom+10, width: scrollView.width-60, height: 52)
        jobtitleField.frame = CGRect(x: 30, y: uicField.bottom+10, width: scrollView.width-60, height: 52)
        signupButton.frame = CGRect(x: 30, y: jobtitleField.bottom+10, width: scrollView.width-60, height: 52)
    }
    
    @objc private func signup() {
        uicField.resignFirstResponder()
        jobtitleField.resignFirstResponder()
        
        guard let uic = uicField.text, let jobtitle = jobtitleField.text, !uic.isEmpty, !jobtitle.isEmpty else {
            alertUserSignUpError()
            return
        }
        
        DatabaseManager.shared.userEmailExists(with: email, completion: {[weak self]exists in
            guard let strongSelf = self else {
                return
            }
            guard !exists else {
                //user already exists
                strongSelf.alertUserSignUpError(message: "Email Account Already Exists")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: strongSelf.email, password: strongSelf.password, completion: {authResult, error in
                guard authResult != nil, error == nil else {
                    print("Error in creating user")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: appUser(firstname: strongSelf.firstname, lastname: strongSelf.lastname, emailAddress: strongSelf.email))
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func alertUserSignUpError(message: String = "Could Not Create Account \nAll Fields must be filled") {
        let alert = UIAlertController(title: "Woops", message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
extension CompleteProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == uicField {
            jobtitleField.becomeFirstResponder()
        } else if textField == jobtitleField {
            signup()
        }
        return true
    }
}

extension CompleteProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Take a Photo or Choose a Photo", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self]_ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as?UIImage else {
            return
        }
        
        self.imageView.image = selectedImage
     
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
