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
    
    func test_stepper_탭_이후_numerator속성값이_변경되는지() {
        let numerator = scheduler.createObserver(String.self)
        let denomitor = scheduler.createObserver(String.self)
        let numeratorMaxValue = scheduler.createObserver(Double.self)
        
        var testInput = retrieveDefaultInputObservable()
        
        testInput.numeratorStepperChanged = scheduler.createColdObservable([
            .next(10, 4),
            .next(20, 6)
        ]).asObservable()
        
        // denomitor 감소에 따라 numerator 스트링값도 변경되어야됨
        testInput.denomitorStepperChanged = scheduler.createColdObservable([
            .next(10, 1.0),
            .next(20, 2.0),
            .next(30, 1.0)
        ]).asObservable()
        
        let testOutput = viewModel.transform(input: testInput)
        
        testOutput.numeratorText
            .drive(numerator)
            .disposed(by: disposeBag)
        
        testOutput.denomitorText
            .drive(denomitor)
            .disposed(by: disposeBag)
        
        testOutput.numeratorMaxValue
            .drive(numeratorMaxValue)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(numerator.events, [
            .next(0, "4"),
            .next(10, "4"),
            .next(20, "6"),
            .next(30, "4")
        ])
    }
    
    func test_tempo슬라이더_조정이후_BPM텍스트가_변경되는지() {
        let bpm = scheduler.createObserver(Float.self)
        
        var testInput = retrieveDefaultInputObservable()
        
        testInput.sliderValueChanged = scheduler.createColdObservable([
            .next(10, Float(122)),
            .next(20, Float(123)),
            .next(30, Float(124))
        ]).asObservable()
        
        let testOutput = viewModel.transform(input: testInput)
        
        testOutput.tempo
            .drive(bpm)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(bpm.events, [
            .next(0, Float(120)),
            .next(10, Float(122)),
            .next(20, Float(123)),
            .next(30, Float(124)),
        ])
    }
    
    override func tearDown() {
        disposeBag = DisposeBag()
    }
    
    func retrieveDefaultInputObservable() -> MetronomeViewModel.Input {
        let controlButton = scheduler.createColdObservable([.next(10, ())])
        let numeratorChanged = scheduler.createColdObservable([.next(10, Double(1))])
        let denomitorChanged = scheduler.createColdObservable([.next(10, Double(1))])
        let sliderChanged = scheduler.createColdObservable([.next(10, Float(122))])
        
        return MetronomeViewModel.Input(controlButtonTapped: controlButton.asObservable(), numeratorStepperChanged: numeratorChanged.asObservable(), denomitorStepperChanged: denomitorChanged.asObservable(), sliderValueChanged: sliderChanged.asObservable())
    }
}
