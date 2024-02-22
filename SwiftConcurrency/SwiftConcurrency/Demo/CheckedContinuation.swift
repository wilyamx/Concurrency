//
//  CheckedContinuation.swift
//  SwiftConcurrency
//
//  Created by William S. Rena on 2/22/24.
//

import SwiftUI

class CheckedContinuationNetworkManager {
    /**
        Async support already
     */
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    
    /**
        Converting from escaping closure into async await
     */
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            // call resume exactly once
            URLSession.shared.dataTask(
                with: URLRequest(url: url)) {
                    data, response, error in
                    if let data = data {
                        continuation.resume(returning: data)
                    }
                    else if let error = error {
                        continuation.resume(throwing: error)
                    }
                    else {
                        continuation.resume(throwing: URLError(.badURL))
                    }
                }
                .resume()
        }
    }
    
    /**
        Old implementation
     */
    func getHeartImageFromDatabase(
        completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 5,
            execute: {
                completionHandler(UIImage(systemName: "heart.fill")!)
            })
    }
    
    /**
        Converting non-asynchronous code to asynchronous code
     */
    func getHeartImageFromDatabase() async -> UIImage {
        return await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationViewModel: ObservableObject {
    let urlString = "https://picsum.photos/300"
    
    var networkManager: CheckedContinuationNetworkManager
    
    @Published var image: UIImage? = nil
    
    init(networkManager: CheckedContinuationNetworkManager) {
        self.networkManager = networkManager
    }
    
    func getImage() async {
        guard let url = URL(string: urlString) else { return }
        do {
            let data = try await networkManager.getData(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch  {
            print(error)
        }
    }
    
    func getImage2() async {
        guard let url = URL(string: urlString) else { return }
        do {
            let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch  {
            print(error)
        }
    }
    
    func getImage3() async {
        self.image = await networkManager.getHeartImageFromDatabase()
    }
    
    func getHeartImage() {
        networkManager.getHeartImageFromDatabase { [weak self] image in
            self?.image = image
        }
    }
}

struct CheckedContinuation: View {
    @StateObject private var viewModel = CheckedContinuationViewModel(
        networkManager: CheckedContinuationNetworkManager()
    )
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
            }
        }
        .task {
            //await viewModel.getImage()
            //await viewModel.getImage2()
            await viewModel.getImage3()
            
            //viewModel.getHeartImage()
        }
    }
}

struct CheckedContinuation_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuation()
    }
}
