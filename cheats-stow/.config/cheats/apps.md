# TUI apps

Default apps by file type (`xdg-open`, yazi `Enter`): dirs → yazi, text → nvim, pdf → zathura, images → swayimg, video/audio → mpv, web → zen. Table: `~/.config/mimeapps.list`.

## zathura (pdf)
`j/k` scroll, `J/K` page, `gg/G`, `/` search `n/N`, `o` open, `+/-` zoom, `a` fit page, `s` fit width, `d` two pages, `r` rotate, `i` invert colours, `f` follow link, `Tab` outline, `q` quit.

## mpv (video, audio)
`Space` pause, `←/→` 5s, `↑/↓` 60s, `[/]` speed, `9/0` volume, `m` mute, `f` fullscreen, `s` screenshot, `v` subtitles, `j` cycle subs, `#` cycle audio, `l` A-B loop, `L` loop file, `q` quit.

## swayimg (images)
`Space`/`n` next, `Backspace`/`p` previous, `+`/`-` zoom, arrows pan, `f` fullscreen, `i` info, `q` quit. Full list: `man swayimg`. `swayimg dir/` browses a dir.

## wiremix (audio, Super+A)
`Tab`/`h`/`l` tabs (Playback, Recording, Output, Input), `j/k` select, `←/→` volume, `m` mute, `d` set default, `q` quit. Keys shown at the bottom.

## bluetuith (bluetooth, Super+Shift+N)
`Ctrl+a` adapter menu (scan, power), `Ctrl+d` device menu, `Enter` on device (connect, pair, trust), `?` help, `q` quit.

## nmtui (network, Super+N)
Menu driven: "Activate a connection" → pick wifi → password. "Edit a connection" for static IPs. Quick from shell: `nmcli dev wifi list`, `nmcli dev wifi connect SSID password PW`.

## btop (Super+I)
`Esc` menu, `m` memory, `p` processes, `n` net, `f` filter, `k` kill, `t` tree, `+/-` expand, `q` quit.

## lazydocker (`ld`)
`Tab`/`[`/`]` panels, `Enter` logs, `d` remove, `s` stop, `r` restart, `x` menu, `?` keys.

## File picker (browsers, flatpaks)
Upload / save dialogs open yazi in a floating window. `Enter` picks, `Space` multi-select, `q` in a folder picks the folder. If a GTK dialog appears instead, portal isn't running: `systemctl --user restart xdg-desktop-portal`.
