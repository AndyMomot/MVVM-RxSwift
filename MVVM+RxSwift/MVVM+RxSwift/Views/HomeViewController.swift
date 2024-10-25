//
//  HomeViewController.swift
//  MVVM+RxSwift
//
//  Created by Andrii Momot on 25.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        outputBindings()
        viewModel.getUser()
    }
}

private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func outputBindings() {
        viewModel.fullNameText.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    }
}
