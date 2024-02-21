//
//  MyTask.swift
//  SwiftConcurrency
//
//  Created by William Rena on 2/21/24.
//

import SwiftUI

class MyTaskViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
            }
        } catch {
            print("[MyTaskViewModel]/fetchImage/error", error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print("[MyTaskViewModel]/fetchImage2/error", error.localizedDescription)
        }
    }
    
    func fetchImageWithDelays() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
            }
        } catch {
            print("[MyTaskViewModel]/fetchImage/error", error.localizedDescription)
        }
    }
}

struct MyTask: View {
    @StateObject private var viewModel = MyTaskViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            // option 1
//            Task {
//                print(Thread.current, Task.currentPriority)
//                await viewModel.fetchImage()
//            }
//            Task {
//                print(Thread.current, Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
            
            // option 2
//            Task(priority: .high) {
//                print("High: \(Thread.current), \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("Medium: \(Thread.current), \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("Low: \(Thread.current), \(Task.currentPriority)")
//            }
            
            // option 3
            Task {
                await viewModel.fetchImageWithDelays()
            }
            
        }
    }
}

struct MyTask_Previews: PreviewProvider {
    static var previews: some View {
        MyTask()
    }
}
