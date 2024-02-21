//
//  AsyncAwait2.swift
//  SwiftConcurrency
//
//  Created by William Rena on 2/21/24.
//

import SwiftUI

class AsyncAwait2ViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2,
            execute: {
                self.dataArray.append("Title1 (Main): \(Thread.current)")
        })
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(
            deadline: .now() + 2,
            execute: {
                let title2 = "Title2 (Bg): \(Thread.current)"
                
                DispatchQueue.main.async {
                    self.dataArray.append(title2)
                    
                    let title3 = "Title3 (Main): \(Thread.current)"
                    self.dataArray.append(title3)
                }
        })
    }
    
    func addAuthor1() async {
        let author1 = "Author1: (Bg) \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author1)
            
            let author2 = "Author2: (Main) \(Thread.current)"
            self.dataArray.append(author2)
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author3 = "Author3: (Bg) \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author3)
            
            let author4 = "Author4: (Main) \(Thread.current)"
            self.dataArray.append(author4)
        }
    }
}

struct AsyncAwait2: View {
    @StateObject private var viewModel = AsyncAwait2ViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
//            viewModel.addTitle1()
//            viewModel.addTitle2()
            
            Task {
                await viewModel.addAuthor1()
                
                let finalText = "Final: (Main) \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
        }
    }
}

struct AsyncAwait2_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwait2()
    }
}
