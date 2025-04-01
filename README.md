# Simple Chat App

A Flutter-based chat application built with Firebase, designed to provide a simple and intuitive messaging experience. This app allows users to register, add friends, chat with them, search for other users by username, and delete conversations or contacts as needed.

## Features

- **User Registration**: Sign up and log in using Firebase Authentication.
- **Add Friends**: Connect with other users by adding them as friends.
- **Real-Time Chat**: Send and receive messages instantly using Firebase Firestore.
- **User Search**: Find users by their username for easy connection.
- **Delete Functionality**: Remove friends or conversations when no longer needed.
- **Cross-Platform**: Works on both Android and iOS devices.

## Technologies Used

- **Flutter**: For building the cross-platform mobile application.
- **Firebase Authentication**: For secure user registration and login.
- **Firebase Firestore**: For real-time database and chat functionality.
- **Dart**: Programming language used with Flutter.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- A [Firebase project](https://firebase.google.com/) set up in the Firebase Console.
- An Android emulator or physical device (for Android), or an iOS simulator/physical device (for iOS).

### Installation

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/NimsaraC/simple_chat_app_flutter.git
   cd simple_chat_app_flutter
   ```

2. **Install Dependencies**  
   Run the following command to install all required packages:
   ```bash
   flutter pub get
   ```

3. **Set Up Firebase**  
   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Add an Android and/or iOS app to your Firebase project.
   - Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) file and place it in the appropriate directory:
     - Android: `android/app/`
     - iOS: `ios/Runner/`
   - Enable Firebase Authentication (Email/Password) and Firestore in the Firebase Console.

4. **Run the App**  
   Connect a device or start an emulator/simulator, then run:
   ```bash
   flutter run
   ```

## Usage

1. **Register**: Open the app and sign up with your email and password.
2. **Add Friends**: Navigate to the friends section and add users by their username.
3. **Chat**: Start a conversation with your added friends in real-time.
4. **Search Users**: Use the search feature to find other users by their username.
5. **Delete**: Remove friends or clear chat history as needed.

## Project Structure

- `lib/`: Contains the Dart source code for the app.
  - `main.dart`: Entry point of the application.
  - `screens/`: UI screens (e.g., login, chat, friends list).
  - `services/`: Firebase integration and business logic.
- `android/`: Android-specific configuration files.
- `ios/`: iOS-specific configuration files.

## Contributing

Contributions are welcome! Feel free to fork the repository and submit a pull request with your improvements.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m "Add your feature"`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

## Contact

For any questions or suggestions, reach out via [GitHub Issues](https://github.com/NimsaraC/simple_chat_app_flutter/issues).

---

