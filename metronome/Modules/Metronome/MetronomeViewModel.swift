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
        
    }
    
    struct Output {
        let numeratorText: Driver<String>
        let denomitorText: Driver<String>
        let beatType: Driver<BeatType>
        let tempo: Driver<Float>
    }
    
    func transform(input: Input) -> Output {
        let numeratorText = BehaviorRelay<String>(value: "4")
        let denomitorText = BehaviorRelay<String>(value: "4")
        let beatType = BehaviorRelay<BeatType>(value: .center)
        let tempo = BehaviorRelay<Float>(value: 120)
        
        return Output(numeratorText: numeratorText.asDriver(), denomitorText: denomitorText.asDriver(), beatType: beatType.asDriver(), tempo: tempo.asDriver())
    }
}
