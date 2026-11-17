# YouTubeDiscordPresence

<p align="left">
    <a href="https://chrome.google.com/webstore/detail/youtubediscordpresence/hnmeidgkfcbpjjjpmjmpehjdljlaeaaa" alt="Category: Social & Communication">
        <img src="https://img.shields.io/badge/Category-Social%20%26%20Communication-blueviolet" /></a>
    <a href="https://github.com/XFG16/YouTubeDiscordPresence#license" alt="MIT License">
        <img src="https://img.shields.io/badge/License-MIT-yellow" /></a>
</p>

**YouTubeDiscordPresence** (YTDP) is a desktop application and browser extension used to create a detailed rich presence for YouTube and YouTube Music on Discord. This fork adds **Linux (x86_64)** support while preserving the original Windows implementation.

<br>

<img height="300px" src="Screenshots/newUiExample.png">

---

## Installation

<p align="left">
    <a href="https://chrome.google.com/webstore/detail/youtubediscordpresence/hnmeidgkfcbpjjjpmjmpehjdljlaeaaa" alt="Chrome Extension">
        <img src="https://img.shields.io/badge/Chrome%20Web%20Store-21%2C000%2B%20Users-critical" /></a>
    <a href="https://chrome.google.com/webstore/detail/youtubediscordpresence/hnmeidgkfcbpjjjpmjmpehjdljlaeaaa" alt="Category: Social & Communication">
        <img src="https://img.shields.io/badge/Total%20Installs-71%2C000%2B-blue" /></a>
</p>

If you've already downloaded the extension, **skip the first step!**

1. Add the extension to your browser. 
    - Access personalization settings later by clicking on the extension (puzzle piece) button at the top right corner of your browser.

<a href="https://chromewebstore.google.com/detail/youtubediscordpresence/hnmeidgkfcbpjjjpmjmpehjdljlaeaaa"><img alt="Download on the Chrome Web Store" src="https://developer.chrome.com/static/docs/webstore/branding/image/HRs9MPufa1J1h5glNhut.png" height=60px></img></a>
<a href="https://addons.mozilla.org/en-US/firefox/addon/youtubediscordpresence/"><img alt="Download on the Firefox Addon Store" src="https://extensionworkshop.com/assets/img/documentation/publish/get-the-addon-178x60px.dad84b42.png" height=60px></img></a>

2. Install the native desktop component for your operating system:

   **Linux (x86_64)** — Node.js 18 or newer, npm, and Python 3 are required. From the repository root, run:

   ```bash
   npm run install:linux --prefix NodeHost
   ```

   The installer registers the native messaging host for Chrome, Chromium, Brave, Vivaldi, Opera, and Firefox (including common Flatpak locations). It installs per-user and does not require `sudo`. Restart your browser and Discord after installation.

   To remove the Linux integration:

   ```bash
   npm run uninstall:linux --prefix NodeHost
   ```

   **Windows (x64)** — Download the latest `YTDPsetup.msi` from [Releases](https://github.com/XFG16/YouTubeDiscordPresence/releases/latest) and run it as usual.

   **Unpacked Chromium extension:** the installer uses the official Chrome Web Store extension ID by default. If you load the extension unpacked, set `YTDP_CHROME_EXTENSION_ID` to the ID shown at `chrome://extensions` before running the installer.

Still confused? Watch the **installation tutorial** on YouTube using [**<ins>this link</ins>**](https://www.youtube.com/watch?v=BWPNqPGFyL4).

---

## Troubleshooting/Known Issues

- The `Listen Along` and `View Channel` buttons in the rich presence don't show when looking at your own profile, but it will show for others. See the example image above. This is a Discord [**<ins>limitation</ins>**](https://github.com/discordjs/RPC/issues/180#issuecomment-2313232518).

- YouTubeDiscordPresence only works with the desktop application of Discord, **not the browser version.**

- Ensure that the `Share my activity` setting under `Activity Privacy` is **turned on**.

Restarting your PC usually resolves any issues, especially on first install.

---

## Bugs, Feature Requests, or Support

Go [here](https://github.com/XFG16/YouTubeDiscordPresence/issues/new/choose) and follow the template!

---

## Building

Desktop application:

- Windows: `npm run compile` (then replace the existing `YTDPwin.exe` in `C:\Program Files\YouTubeDiscordPresence`).
- Linux: `npm ci`, then `npm run precompile`; the native host runs with the system Node.js runtime and does not need a bundled executable.

- Building the `.msi`: Download **Visual Studio 2026** with the **Microsoft Visual Studio Installer Project** extension. Open `Host\YTDPsetup\YTDPsetup.vdproj` and build `YTDPsetup`.

Extension:

- Download the `Extension` directory and load the extension into your browser manually.
- Linux native host registration is handled by `npm run install:linux --prefix NodeHost`.

---

## Miscellaneous

**DISCLAIMER:** this is not a bootleg copy of PreMiD. On a more technical note, it works similar to the Spotify rich presence—it only appears **when a video is playing** and **disappears when there is no video or the video is paused**. In addition, it only displays the presence for videos. Idling and searching are **not displayed**. Features such as exclusions, fully customizable details, and thumbnail coverage are **unique and original** to YouTubeDiscordPresence. YouTubeDiscordPresence has not referenced nor is affiliated with PreMiD in any way whatsoever.

---

## License

Licensed under the [MIT](https://github.com/XFG16/YouTubeDiscordPresence/blob/main/LICENSE.txt) license.
