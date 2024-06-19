//
//  PictureView.swift
//  NASAApp
//
//  Created by Erick Daniel Padilla on 19/06/24.
//

import SwiftUI

struct PictureView: View {
    let picture: PictureOfTheDay
    
    @State private var showsAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                VStack(spacing: 8) {
                    Text(picture.title)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                    Text(picture.copyright?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "NASA")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                Button("See explanation", systemImage: "info.circle", action: showAlert)
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
            }
            .padding(16)
            .background(Material.regular, in: RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 16)
        }
        .padding()
        .alert(picture.title, isPresented: $showsAlert) {
            Button("OK", role: .cancel, action: {})
        } message: {
            Text(picture.explanation.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    func showAlert() {
        showsAlert = true
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
}
