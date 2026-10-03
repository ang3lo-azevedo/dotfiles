/*
 * Vencord, a Discord client mod
 * Copyright (c) 2026 Vendicated and contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import * as DataStore from "@api/DataStore";
import { definePluginSettings } from "@api/Settings";
import definePlugin, { OptionType } from "@utils/types";

// ChannelTabs keeps its bookmarks in the DataStore rather than settings.json,
// so this plugin carries them in a setting and copies them over at startup.
const settings = definePluginSettings({
    bookmarks: {
        type: OptionType.STRING,
        description: "JSON object mapping user IDs to ChannelTabs bookmark lists. Replaces the stored bookmarks of those users on startup.",
        default: "{}"
    }
});

export default definePlugin({
    name: "DeclarativeBookmarks",
    description: "Load ChannelTabs bookmarks from the plugin settings.",
    authors: [
        {
            name: "us.er",
            id: 915238003868323891n
        }
    ],

    settings,

    async start() {
        // Prevent Linux primary selection paste AND Chromium's default external browser open
        document.addEventListener("mousedown", this.onMiddleClick);
        document.addEventListener("auxclick", this.onMiddleClick);

        let declared: Record<string, unknown[]>;
        try {
            declared = JSON.parse(settings.store.bookmarks);
        } catch (e) {
            console.error("[DeclarativeBookmarks] Invalid bookmarks JSON", e);
            return;
        }
        await DataStore.update("ChannelTabs_bookmarks", stored => ({ ...stored, ...declared }));
    },

    stop() {
        document.removeEventListener("mousedown", this.onMiddleClick);
        document.removeEventListener("auxclick", this.onMiddleClick);
    },

    onMiddleClick(e: MouseEvent) {
        if (e.button === 1) {
            // Unconditionally prevent Linux paste and external browser open
            // across the entire Discord interface (servers, channels, bookmarks).
            e.preventDefault();
        }
    }
});
