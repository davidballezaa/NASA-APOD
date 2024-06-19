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
    
    @State private var error: Error? = nil
    @State private var showsUI = true
    
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
            } else if let error = error {
                Text(error.localizedDescription)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ProgressView()
            }
            
            FloatingDatePicker(date: $viewModel.selectedDate)
                .opacity(showsUI ? 1 : 0)
        }
        .background {
            ZStack {
                Color.black
                
                if let selectedPicture = selectedPicture {
                    switch selectedPicture.mediaType {
                    case .image:
                        AsyncImage(url: URL(string: selectedPicture.hdurl ?? selectedPicture.url)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .ignoresSafeArea()
                                .onTapGesture(perform: toggleUI)
                        } placeholder: {
                            ProgressView()
                        }
                        .id(selectedPicture.date)
                    case .video:
                        WebView(url: URL(string: selectedPicture.url)!)
                            .ignoresSafeArea(edges: [])
                            .aspectRatio(1, contentMode: .fit)
                            .id(selectedPicture.date)
                    }
                }
            }
            .ignoresSafeArea()
        }
        .onChange(of: viewModel.selectedDate) {
            downloadIfNeeded()
        }
        .task {
            downloadIfNeeded()
        }
    }
    
    func toggleUI() {
        withAnimation {
            showsUI.toggle()
        }
    }
    
    func downloadIfNeeded() {
        if selectedPicture == nil {
            Task {
                self.error = nil
                do {
                    let picture = try await viewModel.downloadData()
                    modelContext.insert(picture)
                } catch {
                    self.error = error
                }
            }
        } else {
            print("Selected picture already downloaded")
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
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
