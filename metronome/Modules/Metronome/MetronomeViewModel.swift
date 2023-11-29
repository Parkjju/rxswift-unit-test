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
    struct Input {
        
    }
    
    struct Output {
        let numeratorText: Driver<String>
        let denomitorText: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let numeratorText = BehaviorRelay<String>(value: "4")
        let denomitorText = BehaviorRelay<String>(value: "4")
        
        return Output(numeratorText: numeratorText.asDriver(), denomitorText: denomitorText.asDriver())
    }
}
