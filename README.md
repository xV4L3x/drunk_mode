<p align="center">
  <img src="Stuff%20to%20publish/banner.jpg" alt="Drunk Mode Banner" width="700"/>
</p>

<h1 align="center">🍷 Drunk Mode</h1>

<p align="center">
  <b>Save yourself from yourself.</b><br/>
  An iOS tweak that blocks outgoing messages across your favorite apps — so your drunk texts never leave the phone.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS-000?style=for-the-badge&logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/requires-jailbreak-ff6347?style=for-the-badge" />
  <img src="https://img.shields.io/badge/version-0.0.1-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/arch-arm64%20%7C%20arm64e-blue?style=for-the-badge" />
</p>

---

## 💡 The Problem

We've all been there. It's 2 AM, you've had a few too many, and suddenly *every ex deserves a "hey"*. By morning, the damage is done.

**Drunk Mode** is the kill switch your social life needs. Flip it on before the night starts, and your phone physically **cannot** send messages — across iMessage, WhatsApp, Instagram DMs, and Telegram — until you prove you're sober enough to turn it off.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🚫 **Message Blocking** | Intercepts the send button on iMessage, WhatsApp, Instagram, and Telegram. No message leaves your device. |
| ⚙️ **Native Settings Toggle** | A dedicated toggle injected right into the iOS Settings app — sits above Airplane Mode with a custom icon. Feels like a built-in Apple feature. |
| 🧮 **Sobriety Challenge** | Want to turn it off? Solve a random math problem first. If you can't do `326 + 987` at 3 AM, you probably shouldn't be texting. |
| 📳 **Haptic Feedback** | Get it wrong and your phone vibrates to remind you — go to sleep. |
| 🔒 **Zero Bypass** | No "Are you sure?" confirmation. No snooze. No backdoor. Solve the math or put the phone down. |

---

## 📱 Supported Apps

<table align="center">
  <tr>
    <td align="center"><img src="https://img.shields.io/badge/iMessage-34C759?style=for-the-badge&logo=apple&logoColor=white" /></td>
    <td align="center"><img src="https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white" /></td>
    <td align="center"><img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white" /></td>
    <td align="center"><img src="https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white" /></td>
  </tr>
</table>

---

## 📸 Screenshots

<p align="center">
  <img src="Stuff%20to%20publish/IMG_9612.PNG" alt="Settings Toggle" width="230" />
  &nbsp;&nbsp;
  <img src="Stuff%20to%20publish/IMG_9613.PNG" alt="Math Challenge" width="230" />
  &nbsp;&nbsp;
  <img src="Stuff%20to%20publish/IMG_9614.PNG" alt="Message Blocked" width="230" />
</p>

<p align="center">
  <sub><b>Left:</b> Toggle in Settings &nbsp;·&nbsp; <b>Center:</b> Sobriety math challenge &nbsp;·&nbsp; <b>Right:</b> Message blocked on Instagram</sub>
</p>

---

## 🔧 How It Works

Drunk Mode uses **Cydia Substrate** (MobileSubstrate) to hook into the messaging pipelines of supported apps at runtime:

```
iMessage  →  CKChatController.messageEntryViewSendButtonHit:  →  BLOCKED
WhatsApp  →  WAChatBar.sendButtonTapped:                      →  BLOCKED
Instagram →  IGDirectComposer._didTapSend:                    →  BLOCKED
```

When Drunk Mode is active, the original send method is **never called** — instead, the user gets a friendly reminder that they should probably go home.

The toggle is injected as a `PSSpecifier` directly into the iOS Settings root list controller (`PSUIPrefsListController`), making it look and feel completely native.

---

## 🛠 Installation

### Prerequisites

- Jailbroken iOS device (arm64 / arm64e)
- [Theos](https://theos.dev) build environment
- Cydia Substrate / Substitute

### Build from source

```bash
git clone https://github.com/xV4L3x/drunk_mode.git
cd drunk_mode
make package install
```

### Pre-built package

A `.deb` file is available in the [`Stuff to publish/`](Stuff%20to%20publish/) directory — transfer it to your device and install via your preferred package manager (Filza, dpkg, etc.).

```bash
dpkg -i com.xvalex.drunkmode_0.0.1.deb
```

After installation, the device will **respring** automatically.

---

## 🤝 Contributing

Pull requests are welcome! Ideas for future development:

- 🕐 **Scheduled mode** — auto-enable Drunk Mode between custom hours (e.g., 11 PM – 6 AM)
- 📞 **Call blocking** — extend protection to phone calls
- 🎯 **Per-contact blocking** — only protect against *specific* contacts
- 🧩 **More apps** — Snapchat, Facebook Messenger, Discord, etc.
- 🧠 **Harder challenges** — multiplication, word puzzles, or CAPTCHA-style challenges

---

## 📝 License

This project is open-source. Feel free to fork, modify, and distribute.


