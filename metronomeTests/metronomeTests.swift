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
    
    override func setUp() {
        viewModel = MetronomeViewModel()
        input = MetronomeViewModel.Input()
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
}
