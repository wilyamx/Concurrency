//
//  MyTask2.swift
//  SwiftConcurrency
//
//  Created by William Rena on 2/21/24.
//

import SwiftUI

class MyTask2ViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    func fetchImageWithDelays() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
        // very long task
//        for x in array {
//            try Task.checkCancellation()
//        }
        
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
            }
        } catch {
            print("[MyTask2ViewModel]/fetchImage/error", error.localizedDescription)
        }
    }
}

struct MyTask2: View {
    @StateObject private var viewModel = MyTask2ViewModel()
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImageWithDelays()
        }
    }
}

struct MyTask2_Previews: PreviewProvider {
    static var previews: some View {
        MyTask2()
    }
}
