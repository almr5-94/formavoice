<!-- FilePath: Docs/PrivacyWhitepaper.md -->
### Data-Protection Overview

FormaVoice persists every transcription, template, and generated PDF within the application sandbox using file-level protection `NSFileProtectionComplete`, guaranteeing AES-256 encryption while the device is locked or booting. :contentReference[oaicite:24]{index=24}

No network sockets are opened; background tasks are limited to local Core ML warm-ups to conserve battery and maintain radio silence. Neural-Engine scheduling APIs will be adopted once publicly documented for third-party workloads. :contentReference[oaicite:25]{index=25}

Users can export or delete all data through the in-app “Export All” dashboard—no server ever receives personal information.  
