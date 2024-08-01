//
//  ViewController.swift
//  SeSACRxThreads
//
//  Created by gnksbm on 8/1/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class PasswordViewController: UIViewController {
    private var disposeBag = DisposeBag()
    
    private let passwordTextField = SignTextField(
        placeholderText: "비밀번호를 입력해주세요"
    )
    private let descriptionLabel = UILabel()
    private let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureLayout()
        bind()
    }
    
    private func bind() {
        passwordTextField.text = "12345678"
        disposeBag.insert {
            passwordTextField.rx.text.orEmpty
                .map { $0.count > 7 }
                .bind(with: self) { vc, isValidate in
                    vc.nextButton.rx.isEnabled.onNext(isValidate)
                    vc.descriptionLabel.text = isValidate ?
                    nil : "8자 이상 입력해주세요"
                }
            
            nextButton.rx.tap
                .bind(with: self) { vc, _ in
                    
                }
        }
    }
    
    private func configureLayout() {
        [passwordTextField, descriptionLabel, nextButton].forEach {
            view.addSubview($0)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(passwordTextField)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
