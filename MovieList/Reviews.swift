//
//  Reviews.swift
//  MovieList
//
//  Created by Namrata A on 4/17/18.
//  Copyright © 2018 Namrata A. All rights reserved.
//

import Foundation

class Review {
    var userId: NSString?
    var username: NSString?
    var review: NSString?
    
    init(userId: NSString, username: NSString, review: NSString) {
        self.userId = userId
        self.username = username
        self.review = review
    }
}
