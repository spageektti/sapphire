![](https://github.com/spageektti/sapphire/blob/main/assets/banner.png?raw=true)

# Sapphire

**Small in Size, Infinite in Value; Your All-in-One Solution**

Sapphire is an innovative application that provides a multitude of small yet incredibly useful features that are too valuable to overlook but too minor to warrant separate applications. With over 110 unique features and new ones added daily, Sapphire is designed to enhance your experience across various platforms.

## Quick Links
- **[DOWNLOAD](https://github.com/spageektti/sapphire/releases)**
- **[WATCH VIDEO (OLDER APP VERSION)](https://www.youtube.com/watch?v=CxzWOJS6zDo)**
- **[TRY THE APP IN THE BROWSER](https://sapphire.spageektti.cc)**
- **SCROLL DOWN FOR USER AND DEVELOPER GUIDES**

> [!IMPORTANT]  
> The app is not finished. I planned 1000 functions but deliviered only ~160. I will add the rest this summer (will not push to the main branch because of YH4F submission deadline on 30 June). I planned online sync but that is also not implemented because of security and privacy concerns. I am really sorry for all the missing features. Last school year was very hard for me and I couldn't find much time before June. I was basically studying all day for the "Egzamin Ósmoklasisty" which is a very important exam in Poland and for other contests.

> [!WARNING]  
> Note that the browser version was tested only on Windows and Linux in Chrome and Firefox with uBlock Origin both enabled and disabled. If you can please install local version because it supports more features and is better tested.

## Features
- **Cross-Platform Compatibility:** Works seamlessly on Android, iOS, Windows, Linux, Mac, and in your browser.
- **Extensive Feature Set:** Over 110 unique features, with new additions every day.
- **Calculators & Device Information:** Use our calculators and get detailed information about your device or browser.
- **Customizable Experience:** Each feature comes with its own settings and descriptions, allowing you to tailor your experience.
- **Search Functionality:** Easily search for features to find exactly what you need.
- **Personalized Home Screen:** Customize your home screen to suit your preferences.
- **Language & Theme Options:** Change your language and theme to enhance usability.
- **Lightweight:** All of this functionality is packed into an app that is under 50MB.
- **Open Source:** Use, study, share, and improve the app as it is fully open-source. Check the developer guide below to get easy step-by-step guide on how to contribute to the project.

## User Guide
The first thing you have to do is installation of the app. If you are using Windows or Linux with Chrome or Firefox you can use the web version at [sapphire.spageektti.cc](http://sapphire.spageektti.cc). Note that it has limited functionality, it doesn't work offline unless you save the website and some features aren't working because of browser limitations. We have fully-featured applications for Linux and Android. Other platforms will be supported, but I don't have devices to test them yet. If you want to install our app navigate to the [releases page](https://github.com/spageektti/sapphire/releases) and select the right file.

### Installation Guide for `app-release.apk` (Android)

1. **Download the APK:**
   - Visit the [releases page](https://github.com/spageektti/sapphire/releases) and download the `app-release.apk` file to your Android device.

2. **Enable Unknown Sources:**
   - Go to your device's **Settings**.
   - Navigate to **Security** (or **Apps & notifications** on some devices).
   - Enable **Install unknown apps** for the browser or file manager you will use to install the APK.

3. **Install the APK:**
   - Locate the downloaded `app-release.apk` file using a file manager.
   - Tap on the APK file to start the installation process.
   - Follow the on-screen instructions to complete the installation.

4. **Launch Sapphire:**
   - Once installed, you can find Sapphire in your app drawer. Tap to open and start using it.

### Installation Guide for `linux-x64.tar` (Linux)

1. **Download the Tarball:**
   - Visit the [releases page](https://github.com/spageektti/sapphire/releases) and download the `linux-x64.tar` file to your Linux machine.

2. **Extract the Tarball:**
   - Open a terminal window.
   - Navigate to the directory where the `linux-x64.tar` file is located. For example:
     ```bash
     cd ~/Downloads
     ```
   - Extract the tarball using the following command:
     ```bash
     tar -xvf linux-x64.tar
     ```

3. **Navigate to the Extracted Directory:**
   - Change into the directory created by the extraction:
     ```bash
     cd linux-x64
     ```

4. **Run Sapphire:**
   - Make the application executable (if necessary):
     ```bash
     chmod +x sapphire
     ```
   - Start the application by running:
     ```bash
     ./sapphire
     ```

5. **Create a Desktop Entry (Optional):**
   - If you want to create a desktop entry for easier access, you can create a `.desktop` file in `~/.local/share/applications/` with the following content:
     ```ini
     [Desktop Entry]
     Name=Sapphire
     Exec=/path/to/sapphire
     Icon=/path/to/icon.png
     Type=Application
     Categories=Utility;
     ```

Now you are ready to use Sapphire on both Android and Linux!

### Usage



## Developer Guide

To clone the Sapphire repository and run the Flutter app, follow these steps:

1. **Install Flutter:** If you haven't already, install Flutter on your machine. You can find installation instructions at the [Flutter official website](https://flutter.dev/docs/get-started/install).
> [!WARNING]  
> Please use Flutter version `3.27.0`. The latest version doesn't work because of used libraries.


2. **Clone the Repository:**
   Open your terminal or command prompt and run the following command:

   ```bash
   git clone https://github.com/spageektti/sapphire.git
   ```

3. **Navigate to the Project Directory:**
   Change into the project directory:

   ```bash
   cd sapphire
   ```

4. **Get Dependencies:**
   Run the following command to get the necessary dependencies:

   ```bash
   flutter pub get
   ```

5. **Run the Application:**
   You can run the application on an emulator or a physical device using:

   ```bash
   flutter run
   ```

## Interested?
Try Sapphire for yourself and discover the endless possibilities it offers!
