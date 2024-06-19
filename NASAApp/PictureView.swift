//
//  PictureView.swift
//  NASAApp
//
//  Created by Erick Daniel Padilla on 19/06/24.
//

import SwiftUI

struct PictureView: View {
    let picture: PictureOfTheDay
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 8) {
                Text(picture.title)
                Text(picture.copyright?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "NASA")
            }
        }
    }
}

#Preview {
    PictureView(picture: mockPicture)
    .background {
        Image("NasaPicture")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
    .environment(\.colorScheme, .dark)
}
