/*
 * Vencord, a Discord client mod
 * Copyright (c) 2026 Vendicated and contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import { BasicChannelTabsProps, createTab, isBookmarkFolder, settings as tabSettings } from "@equicordplugins/channelTabs/util";
import definePlugin from "@utils/types";
import { GuildChannelStore, SelectedChannelStore } from "@webpack/common";

const MIDDLE_CLICK = 1;
const CHANNEL_PATH = /^\/channels\/(@me|\d+)\/(\d+)(?:\/(\d+))?/;
const DISCORD_HOST = /^((ptb|canary)\.)?discord(app)?\.com$/;
const GUILD_ITEM_PREFIX = "guildsnav___";

type TabTarget = BasicChannelTabsProps & { messageId?: string; };

// ChannelTabs renders bookmarks without any identifying attribute, so the
// bookmark has to be read from the props of the component that owns the node.
function bookmarkFromNode(node: Element): TabTarget | null {
    const key = Object.keys(node).find(k => k.startsWith("__reactFiber$"));
    let fiber = key && (node as any)[key];

    for (let depth = 0; fiber && depth < 10; depth++, fiber = fiber.return) {
        const props = fiber.memoizedProps;
        const bookmark = props?.bookmark ?? (typeof props?.index === "number" ? props.bookmarks?.[props.index] : null);
        if (!bookmark) continue;
        if (isBookmarkFolder(bookmark)) return null;
        return { guildId: bookmark.guildId, channelId: bookmark.channelId };
    }
    return null;
}

function targetFromLink(anchor: HTMLAnchorElement): TabTarget | null {
    const url = new URL(anchor.href, location.origin);
    if (url.origin !== location.origin && !DISCORD_HOST.test(url.hostname)) return null;

    const match = CHANNEL_PATH.exec(url.pathname);
    if (!match) return null;
    return { guildId: match[1], channelId: match[2], messageId: match[3] };
}

function targetFromGuild(item: HTMLElement): TabTarget | null {
    const guildId = item.dataset.listItemId!.slice(GUILD_ITEM_PREFIX.length);
    if (!/^\d+$/.test(guildId)) return null;

    const channelId = SelectedChannelStore.getLastSelectedChannelId(guildId) || GuildChannelStore.getDefaultChannel(guildId)?.id;
    return channelId ? { guildId, channelId } : null;
}

function resolveTarget(el: Element): TabTarget | null {
    const bookmark = el.closest(".vc-channeltabs-bookmark");
    if (bookmark) return bookmarkFromNode(bookmark);

    const anchor = el.closest<HTMLAnchorElement>("a[href]");
    if (anchor) return targetFromLink(anchor);

    const guild = el.closest<HTMLElement>(`[data-list-item-id^="${GUILD_ITEM_PREFIX}"]`);
    if (guild) return targetFromGuild(guild);

    return null;
}

function onMouseDown(e: MouseEvent) {
    if (e.button === MIDDLE_CLICK) e.preventDefault();
}

function onAuxClick(e: MouseEvent) {
    if (e.button !== MIDDLE_CLICK) return;

    // Without this Electron hands the link to the external browser.
    e.preventDefault();

    const target = e.target instanceof Element ? resolveTarget(e.target) : null;
    if (!target) return;

    e.stopPropagation();
    // The trailing true bypasses the one tab per server limit, like the context menu entry does.
    createTab(target, tabSettings.store.openInNewTabAutoSwitch, target.messageId, true, true);
}

export default definePlugin({
    name: "MiddleClickTabs",
    description: "Middle click channels, DMs, servers, bookmarks and message links to open them in a new ChannelTabs tab.",
    authors: [
        {
            name: "us.er",
            id: 915238003868323891n
        }
    ],
    dependencies: ["ChannelTabs"],

    start() {
        document.addEventListener("mousedown", onMouseDown);
        document.addEventListener("auxclick", onAuxClick, true);
    },

    stop() {
        document.removeEventListener("mousedown", onMouseDown);
        document.removeEventListener("auxclick", onAuxClick, true);
    }
});
