//
//  OnboardingViewController.swift
//  SeSACDay22Assignment
//
//  Created by Jack on 1/23/25.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(50)
        }
        startButton.layer.cornerRadius = 25
        startButton.backgroundColor = .white
        startButton.setTitleColor(.darkGray, for: .normal)
        startButton.setTitle("시작하기", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonDidTapped), for: .touchUpInside)
    }
    
    
    @objc
    func startButtonDidTapped() {
        switchRootViewController(rootViewController: ProfileViewController(), isNavigationEmbeded: true)
    }
}
