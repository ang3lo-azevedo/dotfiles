#!/usr/bin/env bash
# Loaded verbatim into a writeShellApplication (see dns.nix); the shebang is a
# comment there and only marks the target shell for shellcheck and shfmt.
if [ "$(id -u)" -ne 0 ]; then
	exec sudo "$0" "$@"
fi

drop_in=/run/systemd/resolved.conf.d/zz-captive-portal.conf

usage() {
	echo "Usage: captive-dns [on|off|status|toggle]"
	echo "  on      use the network's DHCP DNS so a captive portal can load"
	echo "  off     restore encrypted DNS (dnscrypt-proxy)"
	echo "  status  show the current mode"
	echo "  toggle  switch between on and off (default when no argument given)"
}

portal_on() {
	local iface dns
	iface=$(ip route show default | awk '{print $5; exit}')
	if [ -z "${iface:-}" ]; then
		echo "captive-dns: no default route, are you connected to a network?" >&2
		exit 1
	fi

	# nmcli joins multiple DNS servers with " | "; resolved wants them space-separated.
	dns=$(nmcli -g IP4.DNS device show "$iface" | tr '|' ' ')
	if [ -z "${dns// /}" ]; then
		echo "captive-dns: $iface was handed no DNS servers, nothing to switch to" >&2
		exit 1
	fi

	mkdir -p "$(dirname "$drop_in")"
	# Empty assignments reset the lists from the main resolved.conf before we
	# replace them, so 127.0.0.1 (dnscrypt-proxy) no longer shadows the portal DNS.
	{
		echo "[Resolve]"
		echo "DNS="
		echo "DNS=$dns"
		echo "Domains="
		echo "Domains=~."
	} >"$drop_in"

	systemctl stop dnscrypt-proxy.service
	systemctl restart systemd-resolved.service
	resolvectl flush-caches
	echo "captive-dns: ON, using DHCP DNS ($dns) on $iface. Run 'captive-dns off' once you are through the portal."
}

portal_off() {
	rm -f "$drop_in"
	systemctl restart systemd-resolved.service
	systemctl start dnscrypt-proxy.service
	resolvectl flush-caches
	echo "captive-dns: OFF, encrypted DNS restored."
}

case "${1:-toggle}" in
on) portal_on ;;
off) portal_off ;;
toggle)
	if [ -f "$drop_in" ]; then portal_off; else portal_on; fi
	;;
status)
	if [ -f "$drop_in" ]; then
		echo "captive-dns: ON (encrypted DNS bypassed for a captive portal)"
	else
		echo "captive-dns: OFF (encrypted DNS active)"
	fi
	;;
-h | --help | help) usage ;;
*)
	usage
	exit 1
	;;
esac
