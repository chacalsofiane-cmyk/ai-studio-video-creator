import Foundation
import SwiftUI

@MainActor
final class AIStudioViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var prompt: String = ""
    @Published var selectedEffect: String = "cinematic"
    @Published var isGenerating: Bool = false
    @Published var progress: Double = 0
    @Published var generatedVideoURL: URL?
    @Published var errorMessage: String?

    private let service = VideoGeneratorService()

    let effects = [
        "cinematic",
        "explosion",
        "dance",
        "future",
        "portrait",
        "storm"
    ]

    func generateVideo() async {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Veuillez sélectionner une image avant de générer."
            return
        }

        isGenerating = true
        progress = 0.15
        errorMessage = nil

        do {
            let payload = imageData.base64EncodedString()
            let response = try await service.generate(
                imageData: payload,
                prompt: prompt.isEmpty ? "create a cinematic motion with realistic lighting and dramatic camera" : prompt,
                effect: selectedEffect
            )

            progress = 0.8
            if let urlString = response.videoURL,
               let url = URL(string: urlString) {
                generatedVideoURL = url
                progress = 1.0
            } else {
                throw NSError(domain: "AIStudio", code: 4, userInfo: [NSLocalizedDescriptionKey: "URL vidéo invalide."])
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isGenerating = false
    }
}
