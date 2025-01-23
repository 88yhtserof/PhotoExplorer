//
//  BirthdayViewController.swift
//  SeSACDay22Assignment
//
//  Created by Jack on 1/23/25.
//

import UIKit
import SnapKit

class BirthdayViewController: UIViewController {

    let datePicker = UIDatePicker()
    var selectedDate: Date?
    private let notificationName = ProfileViewController.NotificationName.birthday.name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        navigationItem.title = "생일"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(okButtonTapped))
        view.backgroundColor = .white
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.centerX.top.equalTo(view.safeAreaLayoutGuide)
        }
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
    }
    
    @objc func okButtonTapped() {
        UserDefaultsManager.birth = datePicker.date
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: [notificationName: datePicker.date])
        self.navigationController?.popViewController(animated: true)
    }
}
