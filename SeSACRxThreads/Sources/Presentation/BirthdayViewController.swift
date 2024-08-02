//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by gnksbm on 8/2/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class BirthdayViewController: UIViewController {
    private var selectedDate = BehaviorRelay(value: Date.now)
    private var disposeBag = DisposeBag()
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureLayout()
        bind()
    }
    
    private func bind() {
        disposeBag.insert {
            birthDayPicker.rx.date
                .map { selectedDate in
                    selectedDate.distance(to: .now) > 86400 * 365.2422 * 17
                }
                .bind(
                    to: infoLabel.rx.isHidden,
                    nextButton.rx.isEnabled
                )
            
            birthDayPicker.rx.date
                .bind(with: self) { vc, selectedDate in
                    vc.updateDate(selectedDate)
                }
        }
    }
    
    private func updateDate(_ selectedDate: Date) {
        let calendar = Calendar.current
        yearLabel.text = "\(calendar.component(.year, from: selectedDate))년"
        monthLabel.text = "\(calendar.component(.month, from: selectedDate))월"
        dayLabel.text = "\(calendar.component(.day, from: selectedDate))일"
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
