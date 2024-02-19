//
//  AsyncAwait.swift
//  SwiftConcurrency
//
//  Created by William Rena on 2/19/24.
//

import SwiftUI
import Combine

class DownloadImageLoader {
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                return nil
            }
        return image
    }
    
    func downloadWithEscaping(
        completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}

class DownloadImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    var loader: DownloadImageLoader
    
    var cancellables = Set<AnyCancellable>()
    
    init(loader: DownloadImageLoader) {
        self.loader = loader
    }
    
    func fetchImage() {
        self.image = UIImage(systemName: "heart.fill")
    }
    
    func fetchImageByEscaping() {
        loader.downloadWithEscaping { [weak self] image, error in
            if let image = image {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    
    func fetchImageWithCombine() {
        loader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
    }
    
    func fetchWithAsync() async {
        let image = try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
        
    }
}

struct AsyncAwait: View {
    @StateObject private var viewModel = DownloadImageViewModel(
        loader: DownloadImageLoader()
    )
    
    var body: some View {
        ZStack {
            Color.gray
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .cornerRadius(30)
            }
        }
        .onAppear {
            //viewModel.fetchImage()
            //viewModel.fetchImageByEscaping()
            //viewModel.fetchImageWithCombine()
            
            Task {
                await viewModel.fetchWithAsync()
            }
        }
    }
}

struct AsyncAwait_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwait()
    }
}
