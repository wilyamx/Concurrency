//
//  01_HardAndOptionalTry.swift
//  SwiftConcurrency
//
//  Created by William Rena on 2/19/24.
//

import SwiftUI

class DataManager {
    let isActive: Bool = false
    
    func getTitle() throws -> String {
        if isActive {
            return "New text"
        }
        else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitleWithError() throws -> String {
        throw URLError(.badServerResponse)
    }
}

class HardAndOptionalTryViewModel: ObservableObject {
    @Published var text: String = "Starting text"
    
    var dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    // hard try
    func fetchTitleWithHardTry() {
        do {
            let title = try dataManager.getTitle()
            self.text = title
        } catch  {
            self.text = error.localizedDescription
        }
    }
    
    // optional try
    func fetchTitleWithOptionalTry() {
        do {
            // this will not catch
            let title1 = try? dataManager.getTitleWithError()
            if let title = title1 {
                self.text = title
            }
            
            let title2 = try dataManager.getTitle()
            self.text = title2
        } catch  {
            self.text = error.localizedDescription
        }
    }
}

struct HardAndOptionalTry: View {
    @StateObject private var viewModel = HardAndOptionalTryViewModel(
        dataManager: DataManager()
    )
    
    var body: some View {
        Text(viewModel.text)
            .padding(200)
            .frame(width: 200, height: 200)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .onTapGesture {
                viewModel.fetchTitleWithHardTry()
                viewModel.fetchTitleWithOptionalTry()
            }
    }
}

struct HardAndOptionalTry_Previews: PreviewProvider {
    static var previews: some View {
        HardAndOptionalTry()
    }
}
