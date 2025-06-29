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
> The app is not finished. I planned 1000 functions but deliviered only ~160. I will add the rest this summer (will not push to the main branch because of YH4F submission deadline on 30 June). I planned online sync but that is also not implemented because of security and privacy concerns. I am really sorry for all the missing features. Last school year was very hard for me and I couldn't find much time before June. I was basically studying all day for the "Egzamin Ósmoklasisty" which is a very important exam in Poland and for other contests. After all I am still only 15yo...

> [!WARNING]  
> Note that the browser version was tested only on Windows and GNU/Linux in Chrome and Firefox with uBlock Origin both enabled and disabled. If you can please install local version because it supports more features and is better tested.

### For people that will be reviewing my project for Youth Hacking 4 Freedom contest
I want to thank you for organizing this amazing contest. Even if I don't win anything I still learned a lot over the last 6 months. I spent around 150 hours coding this app (not including other things like designing or thinking about new features) - at least that is what hackatime says. I also kindly ask you to not only judge my project by what is already done, but how the app can grow in the future.

## Features
- **Cross-Platform Compatibility:** Works seamlessly on Android, Windows, GNU/Linux, and in your browser. Mac and iOS binaries planned.
- **Extensive Feature Set:** Over 160 unique features, with new additions weekly.
- **Calculators & Device Information:** Use our calculators and get detailed information about your device or browser.
- **Customizable Experience:** Each feature comes with its own settings and descriptions, allowing you to tailor your experience.
- **Search Functionality:** Easily search for features to find exactly what you need.
- **Personalized Home Screen:** Customize your home screen to suit your preferences.
- **Language & Theme Options:** Change your language and theme to enhance usability.
- **Lightweight:** All of this functionality is packed into an app that is under 50MB.
- **Open Source:** Use, study, share, and improve the app as it is fully free (as in freedom) and open source software. Check the developer guide below to get easy step-by-step guide on how to contribute to the project.
- **Offline Support** Access essential features and tools without an internet connection. Users can utilize calculators, view device information, and customize settings even when offline, ensuring a seamless experience regardless of connectivity.
- **Independence from External APIs:** The app operates independently of any company or third-party APIs, ensuring that all processing is done locally on your device. This guarantees enhanced privacy and performance, with the exception of two NASA-related features, which require internet access for data retrieval.
- **Practical Relevance:** Designed with real-world applications in mind. Whether you need quick calculations, device insights, or customizable tools, every feature is crafted to provide practical solutions that fit seamlessly into your everyday life.

## Interested?
Try Sapphire for yourself and discover the endless possibilities it offers!

# User Guide for Sapphire

Welcome to the Sapphire User Guide! Follow the instructions below to install and use the app effectively.

## Installation

### Web Version
If you are using **Windows** or **GNU/Linux** with **Chrome** or **Firefox**, you can access the web version at [sapphire.spageektti.cc](http://sapphire.spageektti.cc). Please note:
- Limited functionality compared to the app.
- Offline access requires saving the website.
- Some features may not work due to browser limitations.

### Full Applications
We offer fully-featured applications for **GNU/Linux** and **Android**. Other platforms will be supported in the future, but testing devices are currently unavailable. To install the app, navigate to the [releases page](https://github.com/spageektti/sapphire/releases) and select the appropriate file.

---

## Installation Guide for Android (`app-release.apk`)

1. **Download the APK:**
   - Visit the [releases page](https://github.com/spageektti/sapphire/releases) and download the `app-release.apk` file to your Android device.

2. **Enable Unknown Sources:**
   - Open your device's **Settings**.
   - Go to **Security** (or **Apps & notifications** on some devices).
   - Enable **Install unknown apps** for the browser or file manager you will use to install the APK.

3. **Install the APK:**
   - Use a file manager to locate the downloaded `app-release.apk` file.
   - Tap on the APK file to initiate the installation process.
   - Follow the on-screen instructions to complete the installation.

4. **Launch Sapphire:**
   - After installation, find Sapphire in your app drawer. Tap to open and start using it.

---

## Installation Guide for GNU/Linux (`linux-x64.tar`)

1. **Download the Tarball:**
   - Visit the [releases page](https://github.com/spageektti/sapphire/releases) and download the `linux-x64.tar` file to your GNU/Linux machine.

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
   - For easier access, create a `.desktop` file in `~/.local/share/applications/` with the following content:
     ```ini
     [Desktop Entry]
     Name=Sapphire
     Exec=/path/to/sapphire
     Icon=/path/to/icon.png
     Type=Application
     Categories=Utility;
     ```

---

## Usage

Please start by watching [this video](https://www.youtube.com/watch?v=CxzWOJS6zDo).

When you launch the app, you will see the home screen. By default, all available functions are grouped into categories. To launch a function, simply click on it. They are designed to be user-friendly, so detailed explanations are not necessary.

### App Bar
On the App Bar (top of the screen), there are two buttons:
- **Information Button (i):** Pressing this button provides basic information about the function, including its name, description, and author. Currently, I am the author of all functions, but as the app is FOSS (Free and Open Source Software), others can add their own features or demos of their apps to Sapphire.
- **Settings Button:** Press this button to customize the function. 

### Example Customization
For instance, you can change the maximum number of digits accepted by the GCD function. If the animation below does not display, please click [this link](https://github.com/user-attachments/assets/25c5c70d-25db-484f-a467-2bead113ab6e).

<img src="https://github.com/user-attachments/assets/25c5c70d-25db-484f-a467-2bead113ab6e" alt="animation showing basic usage of the app" width="300">

### Customizing the Home Screen
You can also customize your home screen:
1. Click the pencil icon in the bottom right corner.
2. Change the order of functions, delete functions, or remove entire categories.
3. To add a new category, scroll to the bottom of the home screen.
4. To add a feature to the home screen, switch to the search page and click the **+** next to a feature, or click on the feature name to test it first.

### Access Settings
Access the settings page to:
- Change the language and theme.
- Export and import backups.
- Reset everything to default.

For a visual guide, watch the tutorial on [YouTube](https://youtu.be/fN9LQB6kzEA).

---

Now you are ready to use Sapphire on both Android and GNU/Linux! Enjoy your experience!


## Developer Guide

### Setup
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

### Adding a New Feature

New features are more than welcome! To ensure a smooth integration, please follow the steps below:

1. **Use the Template**  
   There is a ready-to-use template for a new function. Copy the file located at:
   ```
   lib/functions/template.dart
   ```
   Place it in one of the subfolders of `lib/functions`. For example:
   - If your function is related to math, place it in:
     ```
     lib/functions/math
     ```
   - If it is Android-specific, use:
     ```
     lib/functions/android
     ```
   You can also create new subdirectories as needed.

2. **Add Translation Strings**  
   After coding your feature, add all the translation strings to:
   ```
   assets/translations/en-US.json
   ```
   You can check other pages for examples of how to implement this.

3. **Update Function List**  
   Fill in the `FunctionItem` in the `lib/function_list.dart` file. Note that the name should match the one you used in the translation strings.

4. **Submit Your Changes**  
   Now you can add your function to `default_home_list.dart` and submit a Pull Request (PR)!

If you encounter any issues with these steps, feel free to contact me or open an issue!
