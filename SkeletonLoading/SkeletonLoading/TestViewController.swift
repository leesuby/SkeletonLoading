//
//  ViewController.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 11/11/2022.
//

import UIKit
 
class TestViewController: UIViewController {
    
    
    var collectionView : UICollectionView!
    var dataSource : [User] = [User(name: "Long", image: ""), User(name: "Leesuby", image: "")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    func initView(){
        
        view.backgroundColor = .white
        view.isSkeletonable = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: "userCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isSkeletonable = true
        collectionView.prepareSkeleton(completion: { done in
            self.view.showAnimatedGradientSkeleton()
        })
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(refreshSkeleton)), animated: true)
        
    }

    
    func showGradientSkeleton() {
        let gradient = SkeletonGradient(baseColor: .clouds)
        view.showAnimatedGradientSkeleton(usingGradient: gradient)
        
    }
    
    @objc func refreshSkeleton() {
        self.view.hideSkeleton()
        showGradientSkeleton()
    }
    
    func hideSkeleton() {
        view.hideSkeleton()
    }
    
    
}

extension TestViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 100)
    }
}

extension TestViewController : SkeletonCollectionViewDataSource{
    
    //SkeletonCollectionView
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "userCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        var cell = UICollectionViewCell()
        if let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? UserCell{
            
            userCell.config(user: dataSource[indexPath.row])
            userCell.isSkeletonable = true
            cell = userCell
           
        }
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, prepareCellForSkeleton cell: UICollectionViewCell, at indexPath: IndexPath) {
        let cell = cell as? UserCell
        cell?.isSkeletonable = true
    }
    
    //UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? UserCell{
            
            userCell.config(user: dataSource[indexPath.row])
        
            cell = userCell
        }
        
        return cell
    }
}

