import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    @Binding var image: UIImage?

    var body: some View {
        PhotosPicker(selection: .constant(nil), matching: .images) {
            EmptyView()
        }
        .background(.clear)
    }
}

struct ImagePickerModifier: ViewModifier {
    @Binding var selectedImage: UIImage?

    func body(content: Content) -> some View {
        content
            .photosPicker(isPresented: .constant(false), selection: Binding<PhotosPickerItem?>(
                get: { nil },
                set: { item in
                    guard let item else { return }
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            await MainActor.run {
                                selectedImage = image
                            }
                        }
                    }
                }
            ))
    }
}
