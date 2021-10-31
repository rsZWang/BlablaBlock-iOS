//
//  ProfileViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let radioGroup = RadioButtonGroup()

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var listBtn: ColorButton!
    @IBOutlet weak var historyBtn: ColorButton!
    @IBOutlet weak var listSectionView: UIView!
    @IBOutlet weak var exchangeSelectorView: UIView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var shareBtn: ColorButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radioGroup.add(listBtn)
        radioGroup.add(historyBtn)
        
        exchangeSelectorView.layer.cornerRadius = 3
        exchangeSelectorView.layer.borderWidth = 1
        exchangeSelectorView.layer.borderColor = UIColor.black.cgColor
        
        unitLabel.layer.cornerRadius = 3
        unitLabel.layer.borderWidth = 1
        unitLabel.layer.borderColor = UIColor.black.cgColor
        
        listSectionView.layer.cornerRadius = 6
        listSectionView.layer.borderWidth = 1
        listSectionView.layer.borderColor = UIColor.black.cgColor
        
        shareBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        avatarImageView.makeCircle()
    }

    
}
