import SwiftUI
import AVKit
import PhotosUI

struct ContentView: View {
    @StateObject private var viewModel = AIStudioViewModel()
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 260)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                .frame(height: 220)
                                .foregroundColor(.gray)

                            VStack(spacing: 8) {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 40))
                                Text("Ajouter une photo")
                                    .font(.headline)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }

                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Text("Choisir une image")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .onChange(of: pickerItem) { _, newItem in
                        guard let newItem else { return }
                        Task {
                            if let data = try? await newItem.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                await MainActor.run {
                                    viewModel.selectedImage = image
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Effet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Picker("Effet", selection: $viewModel.selectedEffect) {
                            ForEach(viewModel.effects, id: \ .self) { effect in
                                Text(effect.capitalized).tag(effect)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prompt")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $viewModel.prompt)
                            .frame(minHeight: 110)
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    if viewModel.isGenerating {
                        ProgressView(value: viewModel.progress)
                            .tint(.purple)
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }

                    Button(action: {
                        Task {
                            await viewModel.generateVideo()
                        }
                    }) {
                        Text(viewModel.isGenerating ? "Génération..." : "Générer la vidéo")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .font(.headline)
                            .background(LinearGradient(colors: [.purple, .cyan], startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(viewModel.isGenerating || viewModel.selectedImage == nil)

                    if let videoURL = viewModel.generatedVideoURL {
                        VideoPlayerView(videoURL: videoURL)
                            .frame(height: 420)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding()
            }
            .navigationTitle("AI Studio")
        }
    }
}

#Preview {
    ContentView()
}
