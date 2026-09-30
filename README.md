# AI Studio

This repository contains a starter SwiftUI app and a secure backend proxy for AI-powered video generation.

## Structure

- `Sources/AIStudio` : SwiftUI app source code
- `backend` : Node.js backend used to hide the Agnes API key
- `Package.swift` : Swift Package Manager project definition

## Run the backend

```bash
cd backend
npm install
cp .env.example .env
# fill AGNES_API_KEY in .env
npm start
```

## Run the iOS app

Open the folder in Xcode or run:

```bash
swift build
```

Then update the API URL in `Sources/AIStudio/VideoGeneratorService.swift` if needed.

## Notes

- Do not expose the Agnes API key in the app.
- The app sends image + prompt + effect to the backend.
- The backend calls Agnes AI securely.
