//
//  MainView.swift
//  NASAApp
//
//  Created by Erick Daniel Padilla on 18/06/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pictures: [PictureOfTheDay]
    
    @State private var viewModel = MainViewModel()
    
    @State private var showsUI = true
    // error ...
    
    var selectedPicture: PictureOfTheDay? {
        if appIsRunningInPreview {
            return pictures.first
        }
        return pictures.first(where: { picture in picture.date == viewModel.selectedDateText })
    }
    
    var body: some View {
        ZStack {
            if let selectedPicture = selectedPicture {
                PictureView(picture: selectedPicture)
                    .opacity(showsUI ? 1 : 0)
            }
            // else if let error = error ...
            // else ...
            
            FloatingDatePicker(date: $viewModel.selectedDate)
                .opacity(showsUI ? 1 : 0)
        }
        .background {
            ZStack {
                Color.black
                
                if let selectedPicture = selectedPicture {
                    switch selectedPicture.mediaType {
                    case .image:
                        AsyncImage(url: URL(string: selectedPicture.hdurl ?? selectedPicture.url)) {
                            phase in
                            switch phase {
                            case .empty:
                                ProgressView() // Loading circle
                            case .success(let image):
                                image.resizable()
                            case .failure(let error):
                                Text(error.localizedDescription)
                            @unknown default:
                                fatalError()
                            }
                        }
                    case .video:
                        WebView(url: URL(string: selectedPicture.url)!)
                    }
                }
            }
            .ignoresSafeArea()
        }
        .task {
            downloadIfNeeded()
        }
        .onChange(of: viewModel.selectedDate, {
            downloadIfNeeded()
        })
    }
    
    func toggleUI() {
        withAnimation {
            showsUI.toggle()
        }
    }
    
    func downloadIfNeeded() {
        if selectedPicture == nil {
            Task { // helper to allow async operations
                do {
                    let picture = try await viewModel.downloadData()
                    modelContext.insert(picture)
                } catch {
                    
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environment(\.colorScheme, .dark)
        .modelContainer(previewContainer)
}

@MainActor
let previewContainer: ModelContainer = {
    let container = try! ModelContainer(for: PictureOfTheDay.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(mockPicture)
    return container
}()
