//
//  ViewController.swift
//  metronome
//
//  Created by 박경준 on 11/28/23.
//

import UIKit
import RxCocoa
import RxSwift

class MetronomeViewController: UIViewController {
    
    // MARK: - Subviews
    let box = UIView()
        .then {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .white
        }
    
    let metronomeImageView = UIImageView(image: UIImage(named: "MetronomeCenter"))
        .then {
            $0.contentMode = .scaleAspectFill
        }
    
    let signatureContainer = UIImageView(image: UIImage(named: "SignatureContainer"))
        .then {
            $0.contentMode = .scaleAspectFill
        }
    
    let numeratorLabel = UILabel()
        .then {
            $0.font = .systemFont(ofSize: 32, weight: .bold)
            $0.textColor = .white
            $0.textAlignment = .center
        }
    
    let denomitorLabel = UILabel()
        .then {
            $0.font = .systemFont(ofSize: 32, weight: .bold)
            $0.textColor = .white
            $0.textAlignment = .center
        }
    
    let numeratorStepper = UIStepper()
        .then {
            $0.minimumValue = 1
            $0.stepValue = 1
            $0.maximumValue = 4
            $0.value = 4
        }
    
    let denomitorStepper = UIStepper()
        .then {
            $0.maximumValue = 4
            $0.minimumValue = 1
            $0.stepValue = 1
            $0.value = 1
        }
    
    let signatureTitle = UILabel()
        .then {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.text = "Signature"
        }
    
    let fieldContainer = UIImageView(image: UIImage(named: "FieldContainer"))
    
    let signatureLabel = UILabel()
        .then {
            $0.textAlignment = .center
            $0.text = "4/4"
            $0.textColor = .systemGreen
            $0.font = .systemFont(ofSize: 12, weight: .heavy)
        }
    
    let tempoTitle = UILabel()
        .then {
            $0.text = "Tempo"
            $0.font = .systemFont(ofSize: 16, weight: .medium)
        }
    
    let slider = UISlider()
        .then {
            $0.value = 120
            $0.minimumValue = 60
            $0.maximumValue = 180
            $0.tintColor = .systemGreen
        }
    
    let bpmContainer = UIImageView(image: UIImage(named: "FieldContainer"))
    
    let bpmLabel = UILabel()
        .then {
            $0.textAlignment = .center
            $0.text = "120 BPM"
            $0.font = .systemFont(ofSize: 12, weight: .heavy)
            $0.textColor = .systemGreen
        }
    
    let controlButton = UIButton(type: .system)
        .then {
            $0.setImage(UIImage(named: "BtnPlay")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    
    
    // MARK: - Initialization
    init(viewModel: MetronomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        bindViewModel()
        view.backgroundColor = .darkGray
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var viewModel: MetronomeViewModel
    
    // MARK: - Functions
    func render() {
        view.addSubViews([box, metronomeImageView, signatureContainer, numeratorLabel, denomitorLabel, numeratorStepper, denomitorStepper, signatureTitle, fieldContainer, signatureLabel, tempoTitle, slider, bpmContainer, bpmLabel, controlButton])
        
        box.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
        
        metronomeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(box.snp.top).offset(-20)
            make.centerX.equalTo(box)
        }
        
        signatureContainer.snp.makeConstraints { make in
            make.centerX.equalTo(box)
            make.top.equalTo(metronomeImageView.snp.bottom).offset(14)
        }
        
        numeratorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(signatureContainer)
            make.leading.equalTo(signatureContainer).offset(16)
            make.trailing.equalTo(signatureContainer.snp.centerX)
        }
        
        denomitorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(signatureContainer)
            make.trailing.equalTo(signatureContainer).offset(-16)
            make.leading.equalTo(signatureContainer.snp.centerX)
        }
        
        numeratorStepper.snp.makeConstraints { make in
            make.top.equalTo(signatureContainer.snp.bottom).offset(8)
            make.leading.equalTo(signatureContainer).offset(4)
            make.trailing.equalTo(signatureContainer.snp.centerX).offset(-4)
        }
        
        denomitorStepper.snp.makeConstraints { make in
            make.top.equalTo(signatureContainer.snp.bottom).offset(8)
            make.trailing.equalTo(signatureContainer).offset(-4)
            make.leading.equalTo(signatureContainer.snp.centerX).offset(4)
        }
        
        signatureTitle.snp.makeConstraints { make in
            make.centerX.equalTo(box)
            make.top.equalTo(denomitorStepper.snp.bottom).offset(15)
        }
        
        fieldContainer.snp.makeConstraints { make in
            make.leading.equalTo(numeratorStepper).offset(15)
            make.trailing.equalTo(denomitorStepper).offset(-15)
            make.top.equalTo(signatureTitle.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
        
        signatureLabel.snp.makeConstraints { make in
            make.center.equalTo(fieldContainer)
        }
        
        tempoTitle.snp.makeConstraints { make in
            make.top.equalTo(fieldContainer.snp.bottom).offset(16)
            make.centerX.equalTo(box)
        }
        
        slider.snp.makeConstraints { make in
            make.leading.trailing.equalTo(box).inset(20)
            make.top.equalTo(tempoTitle.snp.bottom).offset(8)
        }
        
        bpmContainer.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(12)
            make.leading.trailing.equalTo(fieldContainer)
            make.height.equalTo(40)
        }
        
        bpmLabel.snp.makeConstraints { make in
            make.center.equalTo(bpmContainer)
        }
        
        controlButton.snp.makeConstraints { make in
            make.centerY.equalTo(box.snp.bottom)
            make.centerX.equalTo(box)
        }
    }
    
    func configUI() {
        
    }
    
    func bindViewModel(){
        let input = MetronomeViewModel.Input(controlButtonTapped: controlButton.rx.tap.asObservable(), numeratorStepperChanged: numeratorStepper.rx.value.asObservable(), denomitorStepperChanged: denomitorStepper.rx.value.asObservable(), sliderValueChanged: slider.rx.value.asObservable())
        let output = viewModel.transform(input: input)
        
        // signature binding
        output.numeratorText.asObservable().bind(to: numeratorLabel.rx.text).disposed(by: disposeBag)
        output.denomitorText.asObservable().bind(to: denomitorLabel.rx.text).disposed(by: disposeBag)
        
        // 메트로놈 타입 바인딩
        output.beatType
            .drive(onNext: { [unowned self] in
                switch $0 {
                case .left:
                    self.metronomeImageView.image = UIImage(named: "MetronomeLeft")
                case .center:
                    self.metronomeImageView.image = UIImage(named: "MetronomeCenter")
                case .right:
                    self.metronomeImageView.image = UIImage(named: "MetronomeRight")
                }
            })
            .disposed(by: disposeBag)
        
        // 템포 바인딩
        output.tempo.asObservable().map { "\(Int($0)) BPM"}.bind(to: bpmLabel.rx.text).disposed(by: disposeBag)
        
        // 템포 슬라이더 바인딩
        output.tempo.map { Float($0) }.drive(onNext: { [unowned self] in
            self.slider.value = $0
        })
        .disposed(by: disposeBag)
        
        // denomitor 변경에 따른 numerator 맥스값 바인딩
        output.numeratorMaxValue.asObservable().bind(to: numeratorStepper.rx.maximumValue).disposed(by: disposeBag)
        
        // 시그니처 바인딩
        output.signatureText.asObservable().bind(to: signatureLabel.rx.text).disposed(by: disposeBag)
    }
}

