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
        var url = URL(string: "https://api.nasa.gov/planetary/apod")!
        url.append(queryItems: [
            URLQueryItem(name: "api_key", value: "wqAghCDBRjVryee2sxAe7PuATpfa2pztxmVgmBSh"),
            URLQueryItem(name: "date", value: selectedDateText),
        ])
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let picture = try JSONDecoder().decode(PictureOfTheDay.self, from: data)
        
        return picture
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
