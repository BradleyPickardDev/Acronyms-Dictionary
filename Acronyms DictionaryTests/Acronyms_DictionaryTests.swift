//
//  Acronyms_DictionaryTests.swift
//  Acronyms DictionaryTests
//
//  Created by Bradley Pickard on 8/6/22.
//

// MIT License

// Copyright (c) 2022 BradleyPickardDev

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import XCTest
@testable import Acronyms_Dictionary
import Combine
class Acronyms_DictionaryTests: XCTestCase {
    var acronymsViewModel:FullFormMeaningsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    override func setUpWithError() throws {
        try super.setUpWithError()
        acronymsViewModel = FullFormMeaningsViewModel(meaningsFetcher: AcronymsDataFetcher())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        acronymsViewModel = nil
    }

    func testAPICallReturningResults() throws {
        let expectation = XCTestExpectation(description: "testAPICallReturningResults")
        acronymsViewModel.word = "HM"
        acronymsViewModel.$apiCallState.dropFirst().sink { [self] state in
            switch state{
            case .loading:
                break
            case.finished:
                XCTAssert(self.acronymsViewModel.meanings.count > 0, "NO data found")
                expectation.fulfill()
            case .error(let error):
                XCTFail(error)
            }
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 20)
    }
    
    func testAPICallReturningEmptyResults() throws {
        let expectation = XCTestExpectation(description: "testAPICallReturningEmptyResults")
        acronymsViewModel.word = ""
        acronymsViewModel.$apiCallState.dropFirst().sink { [self] state in
            switch state{
            case .loading:
                break
            case.finished:
                XCTAssert(self.acronymsViewModel.meanings.count == 0, "There should not be data for empty word")
                expectation.fulfill()
            case .error(let error):
                XCTFail(error)
            }
            
            
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 20)
    }
    
    func testCodableModelsParsing() throws {
        if let filePath = Bundle(for: type(of: self)).url(forResource: "AcronymsMockResponse", withExtension: "json"){
            if let jsonData = try? Data(contentsOf: filePath){
                if let data = try? JSONDecoder().decode(FetchAcronymsModels.self, from: jsonData){
                    XCTAssert(data.count>0,"Parsing error occured")
                }else{
                    XCTFail("Data parsing failed")
                }
            }else{
                XCTFail("File data is not readable")
            }
        }else{
            XCTFail("Mock Response not found")
        }
    }
    
    func testAPIPerformance() throws {
        
        self.measure {
            let expectation = XCTestExpectation(description: "testAPIPerformance")
            acronymsViewModel.word = ""
            acronymsViewModel.$apiCallState.dropFirst().sink { [self] state in
                switch state{
                case .loading:
                    break
                case.finished:
                    XCTAssert(self.acronymsViewModel.meanings.count == 0, "There should not be data for empty word")
                    expectation.fulfill()
                case .error(let error):
                    XCTFail(error)
                }
                
                
            }.store(in: &cancellables)
            wait(for: [expectation], timeout: 30)
        }
    }

}
