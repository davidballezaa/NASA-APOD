//
//  MainViewModel.swift
//  NASAApp
//
//  Created by Erick Daniel Padilla on 19/06/24.
//

import Foundation
import SwiftData

@Observable
class MainViewModel {
    var selectedDate = Date.now
    
    var selectedDateText: String {
        dateFormatter.string(from: selectedDate)
    }
    
    func downloadData() async throws -> PictureOfTheDay {
        
        // Fake API Call when in previews
        if appIsRunningInPreview {
            return mockPicture
        }
        
        // Real API call
        // ...
        
        try await Task.sleep(for: .seconds(1))
        return mockPicture
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
