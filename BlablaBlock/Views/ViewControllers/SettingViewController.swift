//
//  SettingViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var linkCardListStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        linkCardListStackView.spacing = 20
        linkCardListStackView.addArrangedSubview(LinkCard(image: UIImage(named: "ic_setting_binance")!, title: "連結幣安"))
        linkCardListStackView.addArrangedSubview(LinkCard(image: UIImage(named: "ic_setting_ftx")!, title: "連結FTX"))
        let card1 = LinkCard()
        card1.setConnection(state: true)
        linkCardListStackView.addArrangedSubview(card1)
        linkCardListStackView.addArrangedSubview(LinkCard())
        let card2 = LinkCard()
        card2.setConnection(state: true)
        linkCardListStackView.addArrangedSubview(card2)
        linkCardListStackView.addArrangedSubview(LinkCard())
        linkCardListStackView.addArrangedSubview(LinkCard())
        linkCardListStackView.addArrangedSubview(LinkCard())
        linkCardListStackView.addArrangedSubview(LinkCard())
        
        avatarImageView.makeCircle()
    }

}
