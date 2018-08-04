//
//  AddReviewViewController.swift
//  MovieList
//
//  Created by Namrata A on 4/17/18.
//  Copyright © 2018 Namrata A. All rights reserved.
//

import UIKit
import Firebase

class AddReviewViewController: UIViewController, UITextFieldDelegate {
    var databaseReference: DatabaseReference!
    var movieId: Int?
    var username: NSString?
    var review: Review?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        databaseReference = Database.database().reference()
        
        self.reviewTextField.delegate = self
        self.reviewTextField.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    let reviewTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add a Review"
        textField.backgroundColor = .gray
        return textField
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Review", for: UIControlState())
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(addReview), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        view.addSubview(reviewTextField)
        view.addSubview(addButton)
        
        reviewTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        reviewTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        reviewTextField.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        reviewTextField.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    @objc func addReview() {
        
        let userId = Auth.auth().currentUser!.uid
        let reviewText = reviewTextField.text! as NSString
        let movieIdentifier = String("\(movieId!)")
        
        databaseReference.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //read the user data from the snapshot and do whatever with it
            let value = snapshot.value as? NSDictionary
//            self.username = value?["name"] as? NSString
            self.username = "Test Name 1"
            
            self.review = Review(userId: userId as NSString, username: self.username!, review: reviewText)
            self.databaseReference?.child("reviews").child(movieIdentifier).child(userId).child("userId").setValue(self.review?.userId)
            self.databaseReference?.child("reviews").child(movieIdentifier).child(userId).child("name").setValue(self.review?.username)
            self.databaseReference?.child("reviews").child(movieIdentifier).child(userId).child("review").setValue(self.review?.review)
            
        })
        
        let alert = UIAlertController(
            title: "Added!", message: "Review added to movie.",
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
    }
}
