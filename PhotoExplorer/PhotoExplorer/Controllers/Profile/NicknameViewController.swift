//
//  NicknameViewController.swift
//  SeSACDay22Assignment
//
//  Created by Jack on 1/23/25.
//

import UIKit
import SnapKit

class NicknameViewController: UIViewController {

    let textField = UITextField()
    private let notificationName = ProfileViewController.NotificationName.nickname.name
    
    init(nickname: String?) {
        super.init(nibName: nil, bundle: nil)
        textField.text = nickname
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        navigationItem.title = "닉네임"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(okButtonTapped))
        view.backgroundColor = .white
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerX.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        textField.placeholder = "닉네임을 입력해주세요"
    }
    
    @objc func okButtonTapped() {
        guard let text = textField.text else { return }
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [notificationName: text])
        self.navigationController?.popViewController(animated: true)
    }
}
