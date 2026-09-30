import Foundation

struct VideoGeneratorService {
    private let baseURL = URL(string: "http://localhost:3000/api/generate")!

    func generate(imageData: String, prompt: String, effect: String) async throws -> GenerationResponse {
        let payload = GenerationRequest(
            imageData: imageData,
            prompt: prompt,
            effect: effect
        )

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              200...299 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(GenerationResponse.self, from: data)
        if let error = decoded.error, !error.isEmpty {
            throw NSError(domain: "AIStudio", code: 1, userInfo: [NSLocalizedDescriptionKey: error])
        }
        if decoded.success == false {
            throw NSError(domain: "AIStudio", code: 2, userInfo: [NSLocalizedDescriptionKey: "La génération a échoué."])
        }
        if decoded.videoURL == nil || decoded.videoURL?.isEmpty == true {
            throw NSError(domain: "AIStudio", code: 3, userInfo: [NSLocalizedDescriptionKey: "Aucune URL vidéo reçue."])
        }

        return decoded
    }
}
