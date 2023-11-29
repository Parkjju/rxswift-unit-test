//
//  metronomeTests.swift
//  metronomeTests
//
//  Created by 박경준 on 11/28/23.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking

@testable import metronome

final class metronomeTests: XCTestCase {
    var viewModel: MetronomeViewModel!
    var input: MetronomeViewModel.Input!
    var output: MetronomeViewModel.Output!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        viewModel = MetronomeViewModel()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        // 1. 기본 옵저버블 생성 및 Input 객체 추가
        // 2. 테스트 내에서 인풋 특정 요소만 조정 후 output 새롭게 transform
        input = retrieveDefaultInputObservable()
        output = viewModel.transform(input: input)
    }
    
    func test_numerator_denomitor_시작값이_4인지() throws {
        XCTAssertEqual(try output.denomitorText.toBlocking().first(), "4")
        XCTAssertEqual(try output.numeratorText.toBlocking().first(), "4")
    }
    
    func test_메트로놈_첫_타입이_center인지() throws {
        XCTAssertEqual(try output.beatType.toBlocking().first(), .center)
    }
    
    func test_메트로놈_첫_BPM이_120인지() throws {
        XCTAssertEqual(try output.tempo.toBlocking().first(), 120)
    }
    
    func test_버튼_탭_이후_isPlaying_속성값이_변경되는지() {
        let isPlaying = scheduler.createObserver(Bool.self)
        
        var testInput = retrieveDefaultInputObservable()
        
        testInput.controlButtonTapped = scheduler.createColdObservable([
            .next(10, ()),
            .next(20, ()),
            .next(30, ())
        ]).asObservable()
        
        let newOutput = viewModel.transform(input: testInput)
        
        newOutput.isPlaying
            .drive(isPlaying)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(isPlaying.events, [
            .next(0, false),
            .next(10, true),
            .next(20, false),
            .next(30, true)
        ])
    }
    
    override func tearDown() {
        disposeBag = DisposeBag()
    }
    
    func retrieveDefaultInputObservable() -> MetronomeViewModel.Input {
        let controlButton = scheduler.createColdObservable([.next(10, ())])
        
        return MetronomeViewModel.Input(controlButtonTapped: controlButton.asObservable())
    }
}
