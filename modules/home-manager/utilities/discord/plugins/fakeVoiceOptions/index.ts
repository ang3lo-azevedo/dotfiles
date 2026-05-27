/*
 * Vencord, a Discord client mod
 * Copyright (c) 2026 Vendicated and contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import { definePluginSettings } from "@api/Settings";
import definePlugin, { OptionType } from "@utils/types";

export const settings = definePluginSettings({
    fakeMute: {
        type: OptionType.BOOLEAN,
        description: "Show yourself as muted while still being able to speak locally.",
        default: false
    },
    fakeDeafen: {
        type: OptionType.BOOLEAN,
        description: "Show yourself as deafened while still being able to hear locally.",
        default: false
    }
});

export default definePlugin({
    name: "FakeVoiceOptions",
    description: "Fake mute and deafen locally.",
    authors: [
        {
            name: "us.er",
            id: 915238003868323891n
        }
    ],

    settings,

    patches: [
        {
            find: "setSelfMute",
            replacement: [
                {
                    match: /e\.setSelfMute\(n\)/g,
                    replace: "e.setSelfMute($self.settings.store.fakeMute ? false : n)"
                },
                {
                    match: /e\.setSelfDeaf\(t\.deaf\)/g,
                    replace: "e.setSelfDeaf($self.settings.store.fakeDeafen ? false : t.deaf)"
                }
            ]
        }
    ]
});