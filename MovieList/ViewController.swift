//
//  ViewController.swift
//  MovieList
//
//  Created by Namrata A on 3/13/18.
//  Copyright © 2018 Namrata A. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

extension UIImageView {
    func downloadedFrom(path:String) {
        let urlString = "https://image.tmdb.org/t/p/w92/" + path
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!){
            (data, response, err) in
            if err == nil {
                guard let image = data else { return }
                DispatchQueue.main.async {
                    self.image = UIImage(data: image)
                }
            }
    }.resume()
}
}

class myTableViewController: UITableViewController {
    
    let json = JsonParsing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "Movie List"
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.darkGray,NSAttributedStringKey.font: UIFont(name: "Bodoni 72", size: 20) as Any]
    
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " Back", style: .plain, target: nil, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        checkIfUserIsLoggedIn()
        
        json.downloadJson {
            print("JSON download successful")
            self.tableView.reloadData()
        }
        
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid

            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in

                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                    let img = UIImage(named: "Icon-20")
                    let button = UIButton(type: .system)
                    button.setImage(img, for: .normal)
//                    button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                    button.addTarget(self, action: #selector(self.editProfile), for: .touchUpInside)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
                }

            }, withCancel: nil)
        }
    }
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }

        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)

    }
    
    @objc func editProfile(){
        let profileController = LoginViewController()
        self.present(profileController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let number = json.results?.movies.count{
            print(number)
            return number
        }
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
        
        if let posterLink = json.results?.movies[indexPath.row].poster_path {
            print(indexPath.row , json.results?.movies[indexPath.row].poster_path as Any)
            cell.namePoster.downloadedFrom(path: posterLink)
        }
        cell.nameLabel.text = json.results?.movies[indexPath.row].title
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            json.results?.movies.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = json.results?.movies[indexPath.row] {
            let detailController = DetailViewController()
            detailController.movies = movie
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

class MyCell: UITableViewCell{
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.backgroundColor = UIColor.red
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let button = UILabel()
        button.text = "sample text"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font = UIFont.boldSystemFont(ofSize: 15)
        button.font = UIFont(name: "Bodoni 72", size: 18)
        button.textAlignment = .right
        return button
    }()
    
    let namePoster: UIImageView = {
        let button = UIImageView()
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.contentMode = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setUpViews(){
        addSubview(nameLabel)
        addSubview(namePoster)
        
        namePoster.leftAnchor.constraint(equalTo: self.leftAnchor , constant: 10).isActive = true
        namePoster.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        namePoster.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: namePoster.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
}

