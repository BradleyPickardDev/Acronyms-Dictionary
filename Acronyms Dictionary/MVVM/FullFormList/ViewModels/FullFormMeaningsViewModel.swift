//
//  FullFormMeaningsViewModel.swift
//  Acronyms Dictionary
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
import Foundation
import Combine

class FullFormMeaningsViewModel:ObservableObject{
    @Published var word: String = ""
    var meanings: [FetchAcronymsRowViewModel] = []
    @Published var apiCallState:NetworkState = .finished
    private let meaningsFetcher: AcronymsDataFetchable
    private var disposables = Set<AnyCancellable>()
    init(meaningsFetcher:AcronymsDataFetchable, scheduler: DispatchQueue = DispatchQueue(label: "FullFormMeaningsViewModel")){
        self.meaningsFetcher = meaningsFetcher
        $word
          .dropFirst(1)
          .debounce(for: .seconds(0.5), scheduler: scheduler)
          .sink(receiveValue: fetchAcronymsData(for:))
          .store(in: &disposables)

    }
    
    func fetchAcronymsData(for word: String) {
        apiCallState = .loading
        meaningsFetcher.fetchFullForms(for: word)
        .receive(on: DispatchQueue.main)
        .sink(
          receiveCompletion: { [weak self] value in
            guard let self = self else { return }
            switch value {
            case .failure(let error):
                self.meanings = []
                self.apiCallState = .error(error.localizedDescription)
            case .finished:
              break
            }
          },
          receiveValue: { [weak self] topModels in
            guard let self = self else { return }
              self.meanings = topModels.map({$0.lfs}).flatMap({$0}).map({FetchAcronymsRowViewModel(model: $0)})
              self.apiCallState = .finished
        })
        .store(in: &disposables)
    }
}
