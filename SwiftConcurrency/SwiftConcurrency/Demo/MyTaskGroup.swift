//
//  MyTaskGroup.swift
//  SwiftConcurrency
//
//  Created by William Rena on 2/21/24.
//

import SwiftUI

class MyTaskGroupManager {
    let urlString = "https://picsum.photos/300"
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: urlString)
        async let fetchImage2 = fetchImage(urlString: urlString)
        async let fetchImage3 = fetchImage(urlString: urlString)
        async let fetchImage4 = fetchImage(urlString: urlString)
        
        let (image1, image2, image3, image4) = await (
            try fetchImage1,
            try fetchImage2,
            try fetchImage3,
            try fetchImage4
        )
        return [image1, image2, image3, image4]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let urlStrings = [
            urlString,
            urlString,
            urlString,
            urlString,
            urlString
        ]
        
        return try await withThrowingTaskGroup(
            of: UIImage.self,
            body: { group in
                var images: [UIImage] = []
                images.reserveCapacity(urlStrings.count)
                
                for urlString in urlStrings {
                    group.addTask {
                        try await self.fetchImage(urlString: urlString)
                    }
                }
                
                for try await image in group {
                    images.append(image)
                }
                
                return images
        })
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(
                from: url,
                delegate: nil
            )
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
}

class MyTaskGroupViewModel: ObservableObject {
    var dataManager: MyTaskGroupManager
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var images: [UIImage] = []
    
    init(dataManager: MyTaskGroupManager) {
        self.dataManager = dataManager
    }
    
    func getImages() async {
        if let images = try? await dataManager.fetchImagesWithAsyncLet() {
            self.images.append(contentsOf: images)
        }
    }
    
    func getImagesWithTaskGroup() async {
        if let images = try? await dataManager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct MyTaskGroup: View {
    @StateObject private var viewModel = MyTaskGroupViewModel(
        dataManager: MyTaskGroupManager()
    )
    
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
            .navigationTitle("Task Group")
            .task {
                //await viewModel.getImages()
                await viewModel.getImagesWithTaskGroup()
            }
        }
    }
}

struct MyTaskGroup_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskGroup()
    }
}
