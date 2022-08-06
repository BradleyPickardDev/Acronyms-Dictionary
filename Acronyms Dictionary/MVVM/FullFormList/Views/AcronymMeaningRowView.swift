//
//  AcronymMeaningRowView.swift
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
import SwiftUI

struct AcronymMeaningRowView: View {
    var viewModel:FetchAcronymsRowViewModel
    var body: some View {
        HStack(alignment: .top){
            Text(viewModel.model.lf)
            Spacer()
            VStack(alignment:.trailing){
                Text("Since: \(viewModel.model.since)")
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray)
                Text("Frequency: \(viewModel.model.freq)")
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray)

            }
        }
    }
}

struct AcronymMeaningRowView_Previews: PreviewProvider {
    static var previews: some View {
        AcronymMeaningRowView(viewModel: FetchAcronymsRowViewModel(model: LF(lf: "heavy meromyosin", freq: 1, since: 1970, vars: nil)))
    }
}
