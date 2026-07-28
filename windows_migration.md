# Windows Migration Notes

Started: 2026-07-28
Reason: laptop battery issues + no real functional need for Arch anymore (light dev, mostly browsing/gaming). Plan: reinstall Windows, set up WSL for any coding.

## Backup status (USB drive, label `BACKUP`)

Mounted via existing script: `~/.dotfiles/scripts/backup.sh` (rsync + hardlink snapshots, keeps last 5).

Contents of `/home/jawb/usb/BACKUP/`:
- `latest/` -> most recent snapshot (`snapshots/2026-07-28_18-15/`): `documents/`, `pictures/` (incl. `camera/`), `videos/`, `.ssh/`
- `downloads_2026-07-28.tar.gz` — one-off compressed copy of `~/downloads` (4.3G), not part of the rotating snapshots
- `syncthing-config/` — copy of `~/.local/state/syncthing/` (`cert.pem`, `key.pem`, `config.xml`, `index-v2/`) — see Syncthing plan below

Not backed up (intentionally out of scope): `~/media/music` (send-only Syncthing folder, already lives on the home server), `~/repos/*` (see git status below — safety net is GitHub, not the USB drive).

## Source control check (2026-07-28)

**`~/.dotfiles`**
- `hypr/hyprland.conf` screenshot keybinds — committed (`fb5ebe8`, "add screenshot keybinds"). **Not yet pushed** to `origin/main`.
- Branch `monitor-swapping` — 4 commits (dual-monitor setup) that exist nowhere else, not pushed to any remote. **Needs `git push origin monitor-swapping`** before wiping the machine, or the work is gone.
- Branch `laptop` — stale, already fully contained in `main`. No action needed.
- `arch-configs`, `feature/custom-nvim-config` — pushed and in sync.

**`~/repos/*`** — no unpushed commits anywhere. Uncommitted working-tree changes (not urgent, but worth cleaning up before the machine goes away):
- `baumace.github.io` — 3 modified/untracked files
- `bengle` — 11 modified/untracked files
- `resume` — `resume.pdf`, `resume.tex` modified, 2 untracked files

## App support on Windows

- **Nicotine+** — official Windows installer, native support, no WSL needed.
- **Syncthing** — official Windows build exists; recommend **SyncTrayzor** as the Windows-native wrapper (tray icon + runs as a service, matching how it behaves on Linux).
- Install both as native Windows apps, not inside WSL (GUI/tray apps are friction-free natively; WSL is for coding only).

## Syncthing setup plan (avoid a full resync)

Current folders (from `config.xml`):
- `obsidian` — `~/documents/obsidian`, send-receive with home server. Already included in the `documents/` USB backup.
- `music` — `~/media/music`, send-only (this laptop is the source; already on the server separately).

Syncthing skips re-transferring data whenever it finds identical content already at the target path (it hashes and compares blocks, not just timestamps). The usual "have to resync everything" pain comes from starting with an empty folder and a brand-new device identity. Steps to avoid that:

1. Install Syncthing/SyncTrayzor on Windows but **don't let it run yet** — stop the service right after install.
2. Copy the identity + index files from `syncthing-config/` on the USB drive into the new install's config directory (SyncTrayzor: `%LOCALAPPDATA%\Syncthing\`), overwriting the freshly auto-generated `cert.pem`/`key.pem`/`config.xml`. Keeping the same cert/key means the home server still trusts this as the same device — no need to re-approve it there.
3. Copy the actual folder contents into place *before* first launch:
   - `obsidian` -> extract from the `documents/` backup into wherever you want it on Windows (e.g. `C:\Users\<you>\Documents\obsidian`)
   - `music` -> only needed locally if you still want a local copy; it's already safe on the server either way
4. Edit the folder paths in `config.xml` (or the web GUI once it's up) to point at the new Windows-style paths — the old Linux paths (`~/documents/obsidian`, `/home/jawb/media/music`) won't exist anymore.
5. Start Syncthing. It'll rescan, hash the files it finds, match them against the carried-over index, and mark folders up to date — instead of re-downloading from the server over the network.

## Open items

- [ ] Push `main` (1 commit ahead) and `monitor-swapping` branch in `~/.dotfiles`
- [ ] Optionally commit/push WIP in `baumace.github.io`, `bengle`, `resume`
- [ ] Set up Syncthing on Windows per plan above
- [ ] Install Nicotine+ on Windows
- [ ] Set up WSL for coding
