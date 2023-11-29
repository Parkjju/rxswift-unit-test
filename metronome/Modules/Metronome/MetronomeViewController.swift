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
    
    var beatType = BehaviorRelay<BeatType>(value: .center)
    var denomitorText = BehaviorRelay<Int>(value: 4)
    var numeratorText = BehaviorRelay<Int>(value: 4)
    
    enum BeatType: String {
        case left = "MetronomeLeft"
        case right = "MetronomeRight"
        case center = "MetronomeCenter"
    }

    // MARK: - Functions
    func render() {
        view.addSubViews([box, metronomeImageView, signatureContainer, numeratorLabel, denomitorLabel])
        
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
    }
    
    func configUI() {
        
    }
    
    func bindViewModel(){
        numeratorText.map { String($0) }.bind(to: numeratorLabel.rx.text).disposed(by: disposeBag)
        denomitorText.map { String($0) }.bind(to: denomitorLabel.rx.text).disposed(by: disposeBag)
    }
}

