# 🎡 Random Choice App

![Flutter](https://img.shields.io/badge/Flutter-3.19.2-blue?logo=flutter) ![Dart](https://img.shields.io/badge/Dart-3.3.0-blue?logo=dart) ![GitHub](https://img.shields.io/github/license/Phongphisut-Khenchat-Personal/random-choice-app)

A Flutter application that allows users to create a random choice wheel with AdMob integration. Perfect for making fun decisions! 🎉

---

## ✨ Features

- **Add and Remove Choices** 🖋️: Easily manage your options.
- **Spin the Wheel** 🎰: Get a random result with a fun wheel animation.
- **AdMob Integration** 📢: Display banner and interstitial ads.
- **Local Storage** 💾: Save your choices using `shared_preferences`.
- **Beautiful UI** 🌟: Clean and modern design with a touch of fun.

---

## 🚀 Getting Started

Follow these steps to run the app on your local machine:

### Prerequisites
- **Flutter SDK** 🛠️: [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart** 🐦: Included with Flutter
- **Git** 📦: [Install Git](https://git-scm.com/downloads)

### Installation
1. **Clone the Repository** 📥:
   ```bash
   git clone https://github.com/Phongphisut-Khenchat-Personal/random-choice-app.git
   ```
2. **Navigate to the Project** 📂:
   ```bash
   cd random-choice-app
   ```
3. **Install Dependencies** 📚:
   ```bash
   flutter pub get
   ```
4. **Run the App** 🚀:
   ```bash
   flutter run
   ```

## 📦 Dependencies

Here are the main packages used in this project:

| Package | Version | Description |
|---------|---------|-------------|
| flutter_fortune_wheel | ^1.3.1 | For the spinning wheel UI 🎡 |
| get | ^4.6.6 | State management & navigation |
| shared_preferences | ^2.2.2 | Local storage for choices 💾 |
| google_mobile_ads | ^5.1.0 | AdMob integration for ads 📢 |

## 🛠️ Project Structure

```
📂 lib/
   ├── 📄 main.dart               # App entry point
   ├── 📂 bindings/
   │   └── 📄 app_binding.dart    # Dependency injection
   ├── 📂 controllers/
   │   └── 📄 choice_controller.dart  # Logic for choices & wheel
   ├── 📂 views/
   │   └── 📄 home_view.dart      # Main UI
   ├── 📂 services/
   │   └── 📄 ad_service.dart     # AdMob ad management
```

## 🎨 Screenshots

📸 Coming soon! (You can add screenshots of the app here)

## 📝 How to Use

1. **Add Choices** ➕: Enter your options in the input field and press "Add".
2. **Spin the Wheel** 🎯: Click the "Spin Wheel" button to get a random result.
3. **View Results** 🏆: The result will pop up in a beautiful modal.
4. **Manage Choices** 🗑️: Remove individual choices or clear all.
5. **Ads** 📢: Banner ads display at the bottom, and interstitial ads appear after spinning.

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details. 📜

## 🌟 Contributing

Contributions are welcome! Feel free to fork this repository, make improvements, and submit a pull request. 🙌

1. Fork the repository 🍴
2. Create a new branch (`git checkout -b feature/your-feature`) 🌿
3. Commit your changes (`git commit -m "Add your feature"`) ✅
4. Push to the branch (`git push origin feature/your-feature`) 📤
5. Create a Pull Request 🚀

## 📬 Contact

👤 Phongphisut Khenchat

📧 Email: your-email@example.com

🌐 GitHub: Phongphisut-Khenchat-Personal

---

💖 Thank you for checking out Random Choice App!

Let's make decision-making fun together! 🎉
