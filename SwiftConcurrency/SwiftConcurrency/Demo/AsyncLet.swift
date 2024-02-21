//
//  AsyncLet.swift
//  SwiftConcurrency
//
//  Created by William Rena on 2/21/24.
//

import SwiftUI

class AsyncLetViewModel: ObservableObject {
    let url = URL(string: "https://picsum.photos/300")!
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var images: [UIImage] = []
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            }
            else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
    
    func fetchTitle() async -> String {
        return "New Title"
    }
}

struct AsyncLet: View {
    @StateObject private var viewModel = AsyncLetViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let")
            .onAppear {
//                Task {
//                    do {
//                        let image1 = try await viewModel.fetchImage()
//                        viewModel.images.append(image1)
//
//                        let image2 = try await viewModel.fetchImage()
//                        viewModel.images.append(image2)
//                    }
//                    catch {
//
//                    }
//                }
//                Task {
//                    do {
//                        let image3 = try await viewModel.fetchImage()
//                        viewModel.images.append(image3)
//
//                        let image4 = try await viewModel.fetchImage()
//                        viewModel.images.append(image4)
//                    }
//                    catch {
//
//                    }
//                }
                
                Task {
                    do {
                        async let fetchTitle = viewModel.fetchTitle()
                        
                        async let fetchImage1 = viewModel.fetchImage()
                        async let fetchImage2 = viewModel.fetchImage()
                        async let fetchImage3 = viewModel.fetchImage()
                        async let fetchImage4 = viewModel.fetchImage()
                        
                        let (title, image1, image2, image3, image4) = await (
                            fetchTitle,
                            try fetchImage1,
                            try fetchImage2,
                            try fetchImage3,
                            try fetchImage4
                        )
                        viewModel.images.append(contentsOf: [image1, image2, image3, image4])
                        
                        print("\(title)")
                    }
                    catch {
                        
                    }
                }
                
            }
        }
    }
}

struct AsyncLet_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLet()
    }
}
