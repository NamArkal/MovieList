//
//  ReviewTableViewCell.swift
//  MovieList
//
//  Created by Namrata A on 4/17/18.
//  Copyright © 2018 Namrata A. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UICollectionViewCell {
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let reviewDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        //add the views
        backgroundColor = .gray
        
        addSubview(userName)
        addSubview(reviewDescription)
        
        userName.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        userName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        userName.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        reviewDescription.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10).isActive = true
        reviewDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        reviewDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
    }
}
