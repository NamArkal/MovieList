//
//  DetailViewController.swift
//  MovieList
//
//  Created by Namrata A on 3/19/18.
//  Copyright © 2018 Namrata A. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DetailViewController: UIViewController {
    
    var movies: movie? {
        didSet{
            print("Title: ", movies?.title as Any)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.lightGray,NSAttributedStringKey.font: UIFont(name: "Cochin", size: 20) as Any]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icon-16"), style: .plain, target: self, action: #selector(addReview))
        
        let summaryLabel: UILabel = {
            let button = UILabel()
            var myMutableString = NSMutableAttributedString()
            let myString: String = "Summary:"
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font:UIFont(name: "Baskerville", size: 15.0)!])
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:8))
            button.attributedText = myMutableString
            button.translatesAutoresizingMaskIntoConstraints = false
            button.textAlignment = .center
            button.contentMode = .scaleToFill
            button.numberOfLines = 0
            button.textAlignment = NSTextAlignment.justified
            button.font = UIFont(name: "Cochin", size: 15)
            return button
        }()
        
        let overViewLabel: UILabel = {
            let button = UILabel()
            button.text = movies?.overview
            button.translatesAutoresizingMaskIntoConstraints = false
            button.textAlignment = .center
            button.numberOfLines = 0
            button.textAlignment = NSTextAlignment.justified
            button.font = UIFont(name: "Cochin", size: 12)
            return button
        }()
        
        let popularityLabel: UILabel = {
            let button = UILabel()
            var myMutableString = NSMutableAttributedString()
            let myString: String = "Popularity: \(movies?.popularity ?? 0)"
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font:UIFont(name: "Baskerville", size: 15.0)!])
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:11))
            button.attributedText = myMutableString
            button.translatesAutoresizingMaskIntoConstraints = false
            button.textAlignment = .center
            button.contentMode = .scaleToFill
            button.numberOfLines = 0
            button.textAlignment = NSTextAlignment.justified
            button.font = UIFont(name: "Cochin", size: 15)
            return button
        }()
        
        let releaseDateLabel: UILabel = {
            let button = UILabel()
            let myString: String = "Release Date: " + (movies?.release_date)!
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font:UIFont(name: "Baskerville", size: 15.0)!])
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:14))
            button.attributedText = myMutableString
            button.translatesAutoresizingMaskIntoConstraints = false
            button.textAlignment = .center
            button.contentMode = .scaleToFill
            button.numberOfLines = 0
            button.textAlignment = NSTextAlignment.justified
            button.font = UIFont(name: "Cochin", size: 15)
            return button
        }()
        
        let languageLabel: UILabel = {
            let button = UILabel()
            let myString: String = "Language: " + (movies?.original_language)!
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font:UIFont(name: "Baskerville", size: 15.0)!])
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:9))
            button.attributedText = myMutableString
            button.translatesAutoresizingMaskIntoConstraints = false
            button.textAlignment = .center
            button.contentMode = .scaleAspectFit
            button.numberOfLines = 0
            button.textAlignment = NSTextAlignment.justified
            button.font = UIFont(name: "Cochin", size: 15)
            return button
        }()
        
        let ratingLabel: UILabel = {
            let button = UILabel()
            var myMutableString = NSMutableAttributedString()
            let myString: String = "Rating:"
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font:UIFont(name: "Baskerville", size: 15.0)!])
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:7))
            button.attributedText = myMutableString
            button.translatesAutoresizingMaskIntoConstraints = false
            button.textAlignment = .center
            button.contentMode = .scaleToFill
            button.numberOfLines = 0
            button.textAlignment = NSTextAlignment.justified
            button.font = UIFont(name: "Cochin", size: 15)
            return button
        }()
        
        let posters = DetailPoster()
        posters.backdropLink = movies?.backdrop_path
        posters.posterLink = movies?.poster_path
        posters.setupImages()
        let ratingView = RatingControl()
        ratingView.rating = (movies?.vote_average)!
        ratingView.setUpImage()
        view.addSubview(ratingLabel)
        view.addSubview(ratingView)
        view.addSubview(popularityLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(languageLabel)
        view.addSubview(summaryLabel)
        view.addSubview(overViewLabel)
//        view.addSubview(posters)
        
        self.navigationItem.title = movies?.title
        
        let bottomStackView = UIStackView(arrangedSubviews: [ratingLabel, ratingView, popularityLabel, releaseDateLabel, languageLabel, summaryLabel, overViewLabel])
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.distribution = .fillProportionally
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 3
        
        posters.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(bottomStackView)
        view.addSubview(posters)

        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: posters.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
//            bottomStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200.0)
            ])
        
        posters.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
//        posters.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
        posters.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        posters.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        posters.heightAnchor.constraint(equalToConstant: 100).isActive=true
        
    }
    
    @objc func addReview(){
        let controller = AddReviewViewController()
        print(movies?.id as Any)
        controller.movieId = movies?.id
        navigationController?.pushViewController(controller, animated: true)
    }

}

class RatingControl: UIStackView{
    
    var ratingStars = [UIImageView] ()
    var rating: Double!
    var whole: Int!
    var deci: Int!
    var count = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.spacing = 5
        self.distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.spacing = 5
        self.distribution = .fillEqually
    }
    
    func setUpImage(){
        print(rating)
        let fullStarImage:  UIImage = UIImage(named: "FullStar.png")!
        let halfStarImage:  UIImage = UIImage(named: "HalfFullStar.png")!
        let emptyStarImage: UIImage = UIImage(named: "EmptyStar.png")!
        
        ratingPrecision()
        splitRating()
        
        for _ in 0..<whole{
            let star = UIImageView()
            star.image = fullStarImage
            star.translatesAutoresizingMaskIntoConstraints = false
            star.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
            star.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
            addArrangedSubview(star)
            ratingStars.append(star)
        }
        
        if deci != 0 {
            let star = UIImageView()
            star.image = halfStarImage
            star.translatesAutoresizingMaskIntoConstraints = false
            star.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            star.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            addArrangedSubview(star)
            ratingStars.append(star)
        }
        
        for _ in 0..<(5-count){
            let star = UIImageView()
            star.image = emptyStarImage
            star.translatesAutoresizingMaskIntoConstraints = false
            star.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            star.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            addArrangedSubview(star)
            ratingStars.append(star)
        }
        
    }
    
    func ratingPrecision() {
        rating = rating/2
        rating = Double(round(100 * rating)/100)
        print(rating)
    }
    
    func splitRating(){
        let strRating = String(rating)
        let ratingArr = strRating.components(separatedBy: ".")
        whole = Int(ratingArr[0])
        let d = Int(ratingArr[1])!
        if d <= 30{
            deci = 0
        } else if d >= 70 {
            whole! += 1
            deci = 0
        } else {
            deci = d
        }
        
        if deci != 0 {
            count = whole + 1
        } else {
            count = whole
        }
    }
    
}

class DetailPoster: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var backdropLink: String?
    var posterLink: String?
    
    var images: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("came here")
        setupViews()
        self.pictureCollection.bounces = true
        self.pictureCollection.alwaysBounceHorizontal = true
        //pictureCollection.delegate = self
        //pictureCollection.dataSource = self
        
        pictureCollection.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        pictureCollection.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        pictureCollection.heightAnchor.constraint(equalTo: self.heightAnchor).isActive=true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let pictureCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .init(x: 0,y: 0,width: 500, height: 150), collectionViewLayout: layout)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func setupViews() {
        pictureCollection.delegate = self
        pictureCollection.dataSource = self
        addSubview(pictureCollection)
        pictureCollection.register(CollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
    }
    
    func setupImages() {
        images.append(posterLink!)
        images.append(backdropLink!)
        images.append(posterLink!)
        images.append(backdropLink!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return images.count
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.downloadedFrom(path: images[indexPath.row])
        print("done")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 150)
    }
    
    
}

class CollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.frame = CGRect(x: 0, y:0, width: 100, height: 140)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(imageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
    }
}
