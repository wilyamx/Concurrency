//
//  MyTaskGroup.swift
//  SwiftConcurrency
//
//  Created by William Rena on 2/21/24.
//

import SwiftUI

class MyTaskGroupManager {
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
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
}

class MyTaskGroupViewModel: ObservableObject {
    var dataManager: MyTaskGroupManager
    
    @Published var images: [UIImage] = []
    
    init(dataManager: MyTaskGroupManager) {
        self.dataManager = dataManager
    }
}

struct MyTaskGroup: View {
    @StateObject private var viewModel = MyTaskGroupViewModel(
        dataManager: MyTaskGroupManager()
    )
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MyTaskGroup_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskGroup()
    }
}
