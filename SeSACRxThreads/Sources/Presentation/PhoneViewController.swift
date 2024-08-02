//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by gnksbm on 8/1/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class PhoneViewController: UIViewController {
    private var disposeBag = DisposeBag()
    
    private let phoneTextField = SignTextField(
        placeholderText: "연락처를 입력해주세요"
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
        phoneTextField.text = "010"
        disposeBag.insert {
            let inputStatus = phoneTextField.rx.text.orEmpty
                .map {
                    if $0.contains(where: { Int(String($0)) == nil }) {
                        InputStatus.invalidWord
                    } else if $0.count < 10 {
                        InputStatus.outOfRange
                    } else {
                        InputStatus.validated
                    }
                }
                .share()
            
            inputStatus
                .map { $0.isEnabled }
                .bind(to: nextButton.rx.isEnabled)
            
            inputStatus
                .map { $0.description }
                .bind(to: descriptionLabel.rx.text)
            
            nextButton.rx.tap
                .bind(with: self) { vc, _ in
                    vc.navigationController?.pushViewController(
                        BirthdayViewController(),
                        animated: true
                    )
                }
        }
    }
    
    private func configureLayout() {
        [phoneTextField, descriptionLabel, nextButton].forEach {
            view.addSubview($0)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.horizontalEdges.equalTo(phoneTextField)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    enum InputStatus {
        case validated, outOfRange, invalidWord
        
        var isEnabled: Bool {
            switch self {
            case .validated:
                true
            default:
                false
            }
        }
        
        var description: String? {
            switch self {
            case .validated:
                nil
            case .outOfRange:
                "10자 이상 입력해주세요"
            case .invalidWord:
                "숫자만 입력해주세요"
            }
        }
    }
}
