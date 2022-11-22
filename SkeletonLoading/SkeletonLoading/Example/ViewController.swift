//  Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.isSkeletonable = true
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        }
    }
    
    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            avatarImage.isSkeletonable = true
            avatarImage.layer.cornerRadius = avatarImage.frame.width/2
            avatarImage.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var showOrHideSkeletonButton: UIButton!
    
    @IBAction func showOrHideSkeleton(_ sender: Any) {
        showOrHideSkeletonButton.setTitle((view.sk.isSkeletonActive ? "Show skeleton" : "Hide skeleton"), for: .normal)
        view.sk.isSkeletonActive ? hideSkeleton() : showGradientSkeleton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isSkeletonable = true
        view.showSkeleton()
    }
    
    func hideSkeleton() {
        view.hideSkeleton()
    }
    
    func showGradientSkeleton() {
        let gradient = SkeletonGradient(baseColor: .clouds)
        view.showSkeleton(usingGradient: gradient)
    }
}
 

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3 - 10, height: view.frame.width/3 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

// MARK: - SkeletonCollectionViewDataSource
extension ViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CollectionViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell
        cell?.isSkeletonable = true
        return cell
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        return cell
    }
}
