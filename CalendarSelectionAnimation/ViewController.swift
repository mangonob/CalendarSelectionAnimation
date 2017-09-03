//
//  ViewController.swift
//  CalendarSelectionAnimation
//
//  Created by Trinity on 2017/9/3.
//  Copyright © 2017年 Trinity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.itemSize = CGSize(width: 50, height: 50)
        }
    }
    
    fileprivate var prevSelectedIndexPath: IndexPath?
    
    lazy var indicatorBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(colorLiteralRed: 255/255.0, green: 45/255.0, blue: 85/255.0, alpha: 1)
        v.clipsToBounds = true
        v.layer.cornerRadius = 25
        return v
    }()
}


extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer { prevSelectedIndexPath = indexPath }
        
        guard let toCell = collectionView.cellForItem(at: indexPath) else { return }
        guard let selected = prevSelectedIndexPath else {
            toCell.backgroundView = indicatorBackgroundView
            indicatorBackgroundView.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { [weak self] in
                self?.indicatorBackgroundView.transform = CGAffineTransform.identity
            }, completion: nil)
            
            return
        }
        
        guard let fromFrame = collectionView.collectionViewLayout.layoutAttributesForItem(at: selected)?.frame else {
            return
        }
        
        let v = indicatorBackgroundView
        
        if let fromCell = collectionView.cellForItem(at: selected) {
            fromCell.backgroundView = nil
        }
        
        if v.superview != collectionView {
            v.removeFromSuperview()
            v.frame = fromFrame
            collectionView.insertSubview(v, at: 0)
        }
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            v.frame = toCell.frame
        }) { [weak self] (_) in
            if self?.prevSelectedIndexPath == indexPath {
                collectionView.cellForItem(at: indexPath)?.backgroundView = v
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1024
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.backgroundView = indexPath == prevSelectedIndexPath ? indicatorBackgroundView : nil
        cell.clipsToBounds = false
        
        return cell
    }
}

