/*
Copyright (c) 2022–Present Michael Ren
Licensing and distribution info can be found at the GitHub repository
https://github.com/XFG16/YouTubeDiscordPresence
*/

// MAIN VARIABLE INITIALIZATION

const LOGGING = false;

const UPDATE_PRESENCE_MESSAGE = "UPDATE_PRESENCE_DATA";

// REDIRECTION OF DATA FROM INJECTED CONTENT.JS TO BACKGROUND.JS
// A content script can remain in an already-open tab after the extension is
// reloaded. Treat a stale context as a normal shutdown, not an uncaught error.

function isExtensionContextValid() {
    try {
        return Boolean(chrome.runtime && chrome.runtime.id);
    } catch (error) {
        return false;
    }
}

window.addEventListener("SendToLoader", function (message) {
    if (!isExtensionContextValid()) return;

    const detail = message && message.detail;
    if (!detail) return;

    const payload = {
        messageType: UPDATE_PRESENCE_MESSAGE,
        title: detail.title,
        author: detail.author,
        album: detail.album,
        timeLeft: detail.timeLeft,
        duration: detail.duration,
        videoId: detail.videoId,
        channelUrl: detail.channelUrl,
        applicationType: detail.applicationType,
        thumbnailUrl: detail.thumbnailUrl,
    };

    try {
        chrome.runtime.sendMessage(payload, (response) => {
            // Accessing lastError in the callback prevents an unchecked runtime
            // error when the background service worker is restarting.
            try {
                if (chrome.runtime.lastError) {
                    if (LOGGING) console.debug("Presence message was not delivered:", chrome.runtime.lastError.message);
                    return;
                }
                if (LOGGING) console.log("Presence payload delivered to background.js", response);
            } catch (error) {
                // Extension was reloaded while the message callback was pending.
            }
        });
    } catch (error) {
        // The tab may still contain this content script after an extension reload.
        if (LOGGING && !String(error).includes("Extension context invalidated")) {
            console.warn("Unable to send presence payload:", error);
        }
    }
}, false);

// INJECTION OF CONTENT.JS INTO MAIN DOM

try {
    if (isExtensionContextValid()) {
        const mainScript = document.createElement("script");
        mainScript.src = chrome.runtime.getURL("/content.js");
        mainScript.onload = function () {
            this.remove();
        };
        mainScript.onerror = function () {
            this.remove();
            if (LOGGING) console.warn("Failed to inject YouTubeDiscordPresence content.js");
        };
        (document.head || document.documentElement).appendChild(mainScript);
    }
} catch (error) {
    if (LOGGING) console.warn("YouTubeDiscordPresence injection skipped:", error);
}

// NATIVE APP NOT CONNECTED WARNING

// chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
//     if (message.removeWarning) {
//         let warning = document.getElementById("ytdpClientErrorContainer");
//         if (warning) {
//             warning.remove();
//         }
//     }
//     sendResponse(null);
// });

// chrome.storage.sync.get("isNativeConnected", function (result) {
//     if (result.isNativeConnected == false) {
//         fetch(chrome.runtime.getURL('/warning.html')).then(r => r.text()).then(html => {
//             document.body.insertAdjacentHTML('beforeend', html);
//         });
//     }
// });
