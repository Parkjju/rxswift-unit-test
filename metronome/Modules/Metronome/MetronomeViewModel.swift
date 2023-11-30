//
//  MetronomeViewModel.swift
//  metronome
//
//  Created by 박경준 on 11/29/23.
//

import Foundation
import RxCocoa
import RxSwift

class MetronomeViewModel {
    
    var disposeBag = DisposeBag()
    
    enum BeatType: String {
        case left = "MetronomeLeft"
        case right = "MetronomeRight"
        case center = "MetronomeCenter"
    }

    struct Input {
        var controlButtonTapped: Observable<Void>
        var numeratorStepperChanged: Observable<Double>
        var denomitorStepperChanged: Observable<Double>
        var sliderValueChanged: Observable<Float>
    }
    
    struct Output {
        let numeratorText: Driver<String>
        let denomitorText: Driver<String>
        let numeratorMaxValue: Driver<Double>
        let beatType: Driver<BeatType>
        let tempo: Driver<Float>
        let isPlaying: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let numeratorText = BehaviorRelay<String>(value: "4")
        let denomitorText = BehaviorRelay<String>(value: "4")
        let beatType = BehaviorRelay<BeatType>(value: .center)
        let tempo = BehaviorRelay<Float>(value: 120)
        let isPlaying = BehaviorRelay<Bool>(value: false)
        let numeratorMaxValue = BehaviorRelay<Double>(value: 4)
        
        /// 1. 메트로놈 플레이버튼 탭 이벤트
        input.controlButtonTapped
            .subscribe(onNext: {
                isPlaying.accept(!isPlaying.value)
            })
            .disposed(by: disposeBag)
        
        /// 2. 스텝퍼 탭 이후 numerator & denomitor 텍스트 변경
        input.numeratorStepperChanged
            .map { "\(Int($0))" }
            .subscribe(onNext: {
                numeratorText.accept($0)
            })
            .disposed(by: disposeBag)
        
        /// 3. denomitor stepper 값 변경에 따라 numerator 맥스값도 변경되어야 함
        input.denomitorStepperChanged
            .map { Int($0)}
            .subscribe(onNext: {
                denomitorText.accept("\(pow(2, $0 + 1))")
                
                let maxValue = Double(truncating: pow(2, $0 + 1) as NSNumber)
                numeratorMaxValue.accept(maxValue)
                
                if maxValue < Double(numeratorText.value)! {
                    numeratorText.accept("\(Int(maxValue))")
                }
            })
            .disposed(by: disposeBag)
        
        /// 4. 슬라이더 값 변경에 따라 bpm 값 바인딩
        input.sliderValueChanged
            .subscribe(onNext: {
                tempo.accept($0)
            })
            .disposed(by: disposeBag)
        
        return Output(numeratorText: numeratorText.asDriver(), denomitorText: denomitorText.asDriver(), numeratorMaxValue: numeratorMaxValue.asDriver(), beatType: beatType.asDriver(), tempo: tempo.asDriver(), isPlaying: isPlaying.asDriver())
    }
}
