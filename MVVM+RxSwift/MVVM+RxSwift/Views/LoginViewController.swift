//
//  ViewController.swift
//  MVVM+RxSwift
//
//  Created by Andrii Momot on 25.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter data"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var loginTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        inputBindings()
        outputBindings()
    }
}

private extension LoginViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(messageLabel)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        
        loginTextField.becomeFirstResponder()
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            loginTextField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            loginTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            loginTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            nextButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    func inputBindings() {
        loginTextField.rx.text.orEmpty.bind(to: viewModel.loginText).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.passwordText).disposed(by: disposeBag)
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.validate()
        }.disposed(by: disposeBag)
    }
    
    func outputBindings() {
        viewModel.messageText.bind(to: messageLabel.rx.text).disposed(by: disposeBag)
        viewModel.goToHomeController
            .subscribe(onNext: { [weak self] in
                let profileVC = HomeViewController()
                self?.navigationController?.pushViewController(profileVC, animated: true)
            })
            .disposed(by: disposeBag)
        viewModel.triggerAlert
            .subscribe(onNext: { [weak self] in
                let alert = UIAlertController(title: "Error", message: "Invalid login or password", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(cancelAction)
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        // Text did change observer
        viewModel.loginText
            .subscribe { value in
                if let text = value.element {
                    print(text)
                }
            }
            .disposed(by: disposeBag)
    }
}
