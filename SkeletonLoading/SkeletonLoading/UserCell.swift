//
//  UserCell.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 11/11/2022.
//

import UIKit

class UserCell: UICollectionViewCell {
    private var userName : UILabel!
    private var image : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        initContraints()
    }
    
    func initView(){
        contentView.isSkeletonable = true
        image = UIImageView()
        image.image = UIImage(named: "picture")
        image.contentMode = .scaleAspectFill

        
        userName = UILabel()
        userName.textColor = .black
        userName.font = .preferredFont(forTextStyle: .largeTitle, compatibleWith: .none)
        userName.text = "Long"
      
    }
    
    func initContraints(){
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentView.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 30).isActive = true
        userName.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true  
    }
    
    func config(user : User){
        userName.text = user.name
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //    func initLayer(){
    //        let gradient = CAGradientLayer()
    //        gradient.startPoint = CGPoint(x: 0, y: 0.5)
    //        gradient.endPoint = CGPoint(x: 1, y: 0.5)
    //
    //        contentView.layer.addSublayer(gradient)
    //
    //        let animationGroup = makeAnimationGroup()
    //        animationGroup.beginTime = 0.0
    //        gradient.add(animationGroup, forKey: "backgroundColor")
    //
    //        gradient.frame = contentView.bounds
    //        gradient.cornerRadius = contentView.bounds.height / 2
    //
    //
    //    }
    //
    //    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup{
    //        let animationDuration: CFTimeInterval = 1.2
    //        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
    //        anim1.fromValue = UIColor.lightGray.cgColor
    //        anim1.toValue = UIColor.white.cgColor
    //        anim1.beginTime = 0
    //        anim1.duration = animationDuration
    //
    //        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
    //        anim2.fromValue = UIColor.white.cgColor
    //        anim2.toValue = UIColor.lightGray.cgColor
    //        anim2.beginTime = anim1.beginTime + anim1.duration
    //        anim2.duration = animationDuration
    //
    //        let animationGroup = CAAnimationGroup()
    //        animationGroup.animations = [anim1,anim2]
    //        animationGroup.repeatCount = .greatestFiniteMagnitude
    //        animationGroup.duration = anim2.duration + anim2.beginTime
    //        animationGroup.isRemovedOnCompletion = false
    //
    //        if let previousGroup = previousGroup {
    //            animationGroup.beginTime = previousGroup.duration + 0.33
    //        }
    //
    //        return animationGroup
    //    }
}
