//
//  MainViewController.swift
//  CapitalOneApp
//
//  Created by Niranjan Senthilkumar on 5/24/18.
//  Copyright © 2018 NJ. All rights reserved.
//
//
import UIKit
import ResearchKit

class DataViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let barId = "barId"
    
    let headerId = "headerId"


    var userId: String?
    
    let cells = ["pie","bar","pie","bar","pie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    func setupViewControllers(){
        
        collectionView?.backgroundColor = UIColor.rgb(red: 245, green: 241, blue: 237)

        setupNavBar()
        
        collectionView?.register(MainCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(BarCell.self, forCellWithReuseIdentifier: barId)

        
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsetsMake(1, 0, 0, 0)
        
        collectionView?.register(MainHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let text: String = cells[indexPath.row]

        if text == "pie" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainCell
            
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: barId, for: indexPath) as! BarCell
            
            return cell
        }
        

    }
    
    fileprivate func setupNavBar(){
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "info").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleInfo))
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "

        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuButton2x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenu))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 18, height: 230)
    }
    
    @objc func handleMenu(){
        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                          at: .top,
                                          animated: true)
        
        
    }
    
    @objc func handleInfo(){
        let adVC = AdviceController()
        
        self.present(adVC, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MainHeader

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 66)
    }
    
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}


