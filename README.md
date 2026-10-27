# Pneumonia Detection: Mobile App

A mobile app that lets users upload or capture a chest X-ray and get a real-time pneumonia prediction from a deep learning model served through a FastAPI backend.

🧠 **Model training & API repo:** https://github.com/DelliaDeon/pneumonia_backend

## Features
- Pick an X-ray from the gallery or capture one with the camera
- Image preview before submission
- Real-time prediction: **Normal** or **Pneumonia**, with a confidence score
- Loading and error handling (no network, server unreachable, invalid image)
- [Prediction history / other features, keep only what you built]

## How It Works
```
┌──────────────┐   image    ┌────────────────┐   preprocess   ┌──────────────┐
│  Mobile App  │ ─────────▶ │ FastAPI server │ ─────────────▶ │ Trained CNN  │
│  [Flutter]   │ ◀───────── │   /predict     │ ◀───────────── │ [model name] │
└──────────────┘ JSON result└────────────────┘   prediction   └──────────────┘
```
1. The user selects or captures a chest X-ray in the app.
2. The app sends the image to the FastAPI `/predict` endpoint as a multipart upload.
3. The server preprocesses the image and runs it through the final model.
4. The server returns a JSON response, and the app displays the prediction and confidence.

## Final Model
| Detail | Value |
|---|---|
| Architecture | [e.g. MobileNetV2 / ResNet50 / EfficientNet] |
| Input size | [224×224] |
| Test accuracy | [ ] |
| Test recall (Pneumonia) | [ ] |
| Test AUC | [ ] |

Full training details, model comparison, and evaluation are in the [backend repo]([LINK]).

## API Connection

The app communicates with the backend through one endpoint:

**POST `/predict`**: multipart form upload, field name `file`

Example response:
```json
{
  "prediction": "Pneumonia",
  "confidence": 0.94
}
```

### Configuring the backend URL
Set the API base URL in `[lib/config.dart or .env]`:
```dart
const String apiBaseUrl = "http://YOUR_SERVER_IP:8000";
```
- **Android emulator:** use `http://10.0.2.2:8000` to reach `localhost` on your computer
- **Physical device:** use your computer's local IP (e.g. `http://192.168.x.x:8000`), with the phone on the same Wi-Fi
- **Deployed backend:** use your public HTTPS URL

## Tech Stack
| Layer | Technology |
|---|---|
| Mobile app | [Flutter (Dart)] |
| HTTP client | [http / dio] |
| Image selection | [image_picker] |
| Backend | FastAPI (Python) |
| Model | TensorFlow / Keras |


## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- The backend running locally or deployed

### Run the app
```bash
git clone https://github.com/DelliaDeon/[REPO-NAME].git
cd [REPO-NAME]
flutter pub get
flutter run
```

### Run the backend (for local testing)
```bash
git clone https://github.com/DelliaDeon/[BACKEND-REPO].git
cd [BACKEND-REPO]
pip install -r requirements.txt
uvicorn api.main:app --host 0.0.0.0 --port 8000
```
Using `--host 0.0.0.0` lets a physical phone on the same network reach the server.

## Permissions
- **Camera** and **photo library** access, requested when the user picks an image
- **Internet** access, to reach the API

## Limitations and Future Work
- Requires a network connection to the backend
- Predictions are for demonstration, not diagnosis
- On-device inference with TensorFlow Lite for offline use
- Grad-CAM heatmap shown alongside the result
- Save prediction history and export reports

## Author
**Fidelia Nwawulu** 
