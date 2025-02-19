# Pokémon Explorer App 🎮📱

**Pokémon Explorer App** is a mobile application that allows users to explore Pokémon based on their types using data from the **PokéAPI**. The app provides an intuitive interface for filtering, searching, and viewing detailed information about Pokémon.

## 🚀 Features
- **Type Selection & Search**: Users can select one of **10 Pokémon types** (Fire, Water, Grass, Electric, Dragon, Psychic, Ghost, Dark, Steel, Fairy) and search for Pokémon by name within the selected type.
- **Pokémon List Display**: Shows a paginated list of Pokémon from the selected type, initially displaying **10 Pokémon**, with an option to **load more**.
- **Pokémon Details**: Displays Pokémon **name, image, and key stats (HP, Attack, Defense)** in an easy-to-read format.

## 🔗 API & Technology Stack
- **PokéAPI**: Used to fetch Pokémon data dynamically.
- **Flutter + Dio**: For fast & efficient API handling and UI responsiveness.
- **State Management**: Efficient state updates ensure smooth interactions.

# App Demo

![App Demo](app_demo.gif)

# How to Run
This guide provides step-by-step instructions to run the **Pokemon Explorer App** on an **Android** device.

## Prerequisites

Before running the app, ensure you have the following installed:

- **Flutter SDK** (latest stable version) → [Download Flutter](https://flutter.dev/docs/get-started/install)
- **Android Studio** (or an emulator setup) → [Download Android Studio](https://developer.android.com/studio)
- **Android SDK** (installed with Android Studio)
- **A physical Android device** (USB debugging enabled) or an emulator
- **Git** (to clone the repository) → [Download Git](https://git-scm.com/)

## Installation

### 1. Clone the Repository
Open a terminal and run:
```sh
git clone https://github.com/kirisaki-momotaro/pokemon-explorer-app.git
cd pokemon-explorer-app
```

### 2. Install Dependencies
Ensure you have all the required dependencies installed:
```sh
flutter pub get
```

### 3. Connect an Android Device or Start an Emulator
#### Option 1: Use a Physical Device
1. Enable **Developer Mode** and **USB Debugging** on your Android device.
2. Connect your device via USB.
3. Run:
   ```sh
   flutter devices
   ```
   You should see your device listed.

#### Option 2: Use an Emulator
1. Open **Android Studio**.
2. Go to **AVD Manager** and start an emulator.
3. Run:
   ```sh
   flutter devices
   ```
   The emulator should be listed.

### 4. Run the App
To launch the app on your connected device or emulator, run:
```sh
flutter run
```
This will build and deploy the app.

## Troubleshooting

### Issue: No Connected Devices Found
- Ensure your device is connected via USB and **USB Debugging** is enabled.
- Restart **adb**:
  ```sh
  adb kill-server
  adb start-server
  ```

### Issue: Gradle Build Fails
- Run:
  ```sh
  flutter clean
  flutter pub get
  ```
- Ensure you have **Java 17+** installed and configured.

### Issue: Emulator Runs Slow
- Allocate more **RAM** and **CPU cores** in AVD Manager.
- Try using a **physical device** instead.

## Additional Commands

### Check Available Devices
```sh
flutter devices
```

### Run in Release Mode (for better performance)
```sh
flutter run --release
```

### Build APK for Distribution
```sh
flutter build apk
```
The generated APK will be in `build/app/outputs/flutter-apk/`.

## Notes
- The app requires **internet access** to fetch Pokémon data.
- Ensure the **API endpoints** used in the app are active.

Happy exploring! 🎮

