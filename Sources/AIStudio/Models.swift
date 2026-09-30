import Foundation

struct GenerationRequest: Codable {
    let imageData: String
    let prompt: String
    let effect: String
}

struct GenerationResponse: Codable {
    let success: Bool
    let videoURL: String?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case success
        case videoURL = "video_url"
        case error
    }
}
