//
//  AcronymsDataFetcher.swift
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
protocol AcronymsDataFetchable{
    func fetchFullForms(for word:String)->AnyPublisher<FetchAcronymsModels,AcronymDataError>
}
class AcronymsDataFetcher:AcronymsDataFetchable{
    func fetchFullForms<T:Decodable>(for word: String) -> AnyPublisher<T, AcronymDataError> {
        guard let url = AcronymsDataAPI.makeAcronymsAPIURLComponents(for: word).url else {
            return Fail(error: AcronymDataError.dataInconsistency(description: "URL couldn't be parsed")).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                AcronymDataError.networking(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { response in
                decode(response.data)
            }
            .eraseToAnyPublisher()
    }
}
