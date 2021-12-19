//
//  SettingViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit
import RxSwift

class SettingViewController: BaseViewController, LinkCardViewDelegate {
    
    @Inject let 
    
    private lazy var binanceLinkCard = LinkCardView(self, image: UIImage(named: "ic_setting_binance")!, title: "連結幣安")
    private lazy var ftxLinkCard = LinkCardView(self, image: UIImage(named: "ic_setting_ftx")!, title: "連結FTX")

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var linkCardViewListStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        linkCardViewListStackView.spacing = 20
        linkCardViewListStackView.addArrangedSubview(binanceLinkCard)
        linkCardViewListStackView.addArrangedSubview(ftxLinkCard)
        
        signOutButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.tabBarController!.navigationController!.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeCircle()
    }
    
    func onTap() {
        let vc = LinkExchangeViewController()
        present(vc, animated: true)
    }

}
