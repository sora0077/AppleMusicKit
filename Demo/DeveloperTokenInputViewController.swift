//
//  DeveloperTokenInputViewController.swift
//  Demo
//
//  Created by 林 達也 on 2017/07/18.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

final class DeveloperTokenInputViewController: UIViewController {
    private let gradientLayer = CAGradientLayer.appleMusicLayer()
    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DeviceToken"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(saveAction))

        view.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true

        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 8
        textView.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        textView.text = UserDefaults.standard.string(forKey: "DeviceToken") ?? ""
        textView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    @objc
    private func saveAction() {
        let token = textView.text ?? ""
        UserDefaults.standard.set(token, forKey: "DeviceToken")
        UserDefaults.standard.synchronize()
        Session.shared.authorization = Authorization(developerToken: token)
        navigationController?.popViewController(animated: true)
    }
}
