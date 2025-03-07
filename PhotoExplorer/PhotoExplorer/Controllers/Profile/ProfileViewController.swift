//
//  ProfileViewController.swift
//  SeSACDay22Assignment
//
//  Created by Jack on 1/23/25.
//

import UIKit
import SnapKit

enum Level: Int {
    case top
    case middle
    case bottom
    
    var title: String {
        switch self {
        case .top:
            return "상"
        case .middle:
            return "중"
        case .bottom:
            return "하"
        }
    }
}

protocol ProfileViewControllerDelegate: AnyObject {
    func birthDayDataHandler(_ value: Date)
}

class ProfileViewController: UIViewController {
    
    enum NotificationName: String {
        case nickname
        case birthday
        case level
        
        var name: Notification.Name {
            return Notification.Name(self.rawValue)
        }
    }

    let saveButton = UIButton()
    
    let nicknameButton = UIButton()
    let birthdayButton = UIButton()
    let levelButton = UIButton()
    
    let nicknameLabel = UILabel()
    let birthdayLabel = UILabel()
    let levelLabel = UILabel()
    
    var userInfo: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureData()
        NotificationCenter.default.addObserver(self, selector: #selector(nickNameObserver), name: NotificationName.nickname.name, object: nil)
    }
    
    @objc func nickNameObserver(notification: Notification) {
        let nickname = notification.userInfo?[NotificationName.nickname.name] as? String
        nicknameLabel.text = nickname
        if self.userInfo == nil {
            self.userInfo = UserInfo()
        }
        self.userInfo?.nickname = nickname
    }
    
    @objc func birthdayObserver(notification: Notification) {
        guard let date = notification.userInfo?[NotificationName.birthday.name] as? Date else { return }
        birthdayLabel.text = DateFormatterManager.shared.createdAtFormatter.string(from: date)
    }
    
    @objc func levelObserver(notification: Notification) {
        guard let level = notification.userInfo?[NotificationName.level.name] as? Int else { return }
        levelLabel.text = Level(rawValue: level)?.title
    }
    
    func configureView() {
        navigationItem.title = "프로필 화면"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "탈퇴하기", style: .plain, target: self, action: #selector(leaveButtonTapped))
        view.backgroundColor = .white
        
        view.addSubview(nicknameButton)
        view.addSubview(birthdayButton)
        view.addSubview(levelButton)
        
        view.addSubview(nicknameLabel)
        view.addSubview(birthdayLabel)
        view.addSubview(levelLabel)
        
        nicknameButton.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        birthdayButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.top.equalTo(nicknameButton.snp.bottom).offset(24)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }

        levelButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.top.equalTo(birthdayButton.snp.bottom).offset(24)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalTo(nicknameButton.snp.trailing).offset(24)
            make.height.equalTo(50)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalTo(birthdayButton.snp.trailing).offset(24)
            make.height.equalTo(50)
        }

        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalTo(levelButton.snp.trailing).offset(24)
            make.height.equalTo(50)
        }

        nicknameButton.addTarget(self, action: #selector(nicknameButtonTapped), for: .touchUpInside)
        birthdayButton.addTarget(self, action: #selector(birthButtonTapped), for: .touchUpInside)
        levelButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        
        nicknameButton.setTitleColor(.black, for: .normal)
        birthdayButton.setTitleColor(.black, for: .normal)
        levelButton.setTitleColor(.black, for: .normal)
        
        nicknameButton.setTitle("닉네임", for: .normal)
        birthdayButton.setTitle("생일", for: .normal)
        levelButton.setTitle("레벨", for: .normal)

        nicknameLabel.text = "NO NAME"
        nicknameLabel.textColor = .lightGray
        nicknameLabel.textAlignment = .right
        
        birthdayLabel.text = "NO DATE"
        birthdayLabel.textColor = .lightGray
        birthdayLabel.textAlignment = .right
        
        levelLabel.text = "NO LEVEL"
        levelLabel.textColor = .lightGray
        levelLabel.textAlignment = .right
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(50)
        }
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = .darkGray
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setTitle("저장", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonDidTapped), for: .touchUpInside)
    }
    
    func configureData() {
        self.userInfo = UserDefaultsManager.userInfo
        guard let userInfo else { return }
        nicknameLabel.text = userInfo.nickname
        birthdayLabel.text = userInfo.birth != nil ? DateFormatterManager.shared.createdAtFormatter.string(from: userInfo.birth!) : nil
        levelLabel.text = userInfo.level != nil ? Level(rawValue: userInfo.level!)?.title : nil
    }
    
    @objc func leaveButtonTapped() {
        UserDefaultsManager.isOnboardingCompleted = false
        UserDefaultsManager.userInfo = nil
        switchRootViewController(rootViewController: OnboardingViewController())
    }
    
    @objc func nicknameButtonTapped() {
        let vc = NicknameViewController(nickname: userInfo?.nickname)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func birthButtonTapped() {
        let vc = BirthdayViewController(birthday: userInfo?.birth ?? Date())
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func levelButtonTapped() {
        let vc = LevelViewController(level: userInfo?.level ?? 0)
        vc.handler = { level in
            self.levelLabel.text = Level(rawValue: level)?.title
            if self.userInfo == nil {
                self.userInfo = UserInfo()
            }
            self.userInfo?.level = level
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func saveButtonDidTapped() {
        UserDefaultsManager.userInfo = userInfo
        showOKAlert(title: "저장", message: "성공적으로 저장되었습니다")
    }
}

extension ProfileViewController: ProfileViewControllerDelegate {
    func birthDayDataHandler(_ value: Date) {
        birthdayLabel.text = DateFormatterManager.shared.createdAtFormatter.string(from: value)
        if self.userInfo == nil {
            self.userInfo = UserInfo()
        }
        self.userInfo?.birth = value
    }
}
