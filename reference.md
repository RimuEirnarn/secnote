# Secure Note Implementation

The Application should implement 3 interfaces.
CLI, Web, and GUI.
Then, there's should be a core implementation AKA core-server.

Core implementation listen at /run/app-name/sock or /run/user/app-name/sock, correspond to core installation.

PID file will be used to check the locking and PID checks. (runtime-dir/pid)

CRUD Operation: Create Read Update Delete must be implemented for core

Database will be using sqlite. File for local installation.
For local, notes are located at ~/.config/app-dir/data/notes

But, file for local can be altered into using sqlite if user sets corresponding config.

All notes are encrypted.

Local Notes schema:

```
Notes/
  note_id
  title
  content
  updated_at
  created_at
```

Global Schema:

```
Users/
   user_id
   hashed
   salted
   username

Notes/
   note_id
   user_id
   title
   content
   updated_at
   created_at
```

Make sure security is considered.

## Installations

### Global

Global installation may be used as online or offline uses. As server listens to /run/app-name/sock

Global installation requires /var/local/data as base directory to put application data.
extend it, /var/local/data/app-directory as example. The content should not be very different from local.

Global implementation installs specific systemd service to create custom directory to /run/app-name since /run owned by root and not world-writable.

### Local

Offline/local installation only allows offline uses. Local server listen to /run/user/<uid>/app-name/sock.
Better if local depends on true core. This bypasses the use for daemon process but requires to input password every operations.
As tradeoff, install options be required. "local" or "offline".

App directory are installed to ~/.config/app-name.
Executables are stored to ~/.local/bin

### Modes & Interfaces

**Future notation**: if a path starts with /app, expand it as either ~/.config/app-name or /var/local/data/app-name

### CLI Interface

CLI Interface brings 5 commands. `list`, `read`, `edit`, `delete`, `trash`.
For `trash`, only 2 sub-commands: `restore`, `purge`.

Edit should bring user's favorite CLI tools like VIm, Emacs, Nano, etc.

Deletion for default to trash. Trash are in /app/data/trash

Can connect to `offline`, `local`, `global`, and `server` mode.

### GUI Interface

GUI interface may use GTk, TKinter, or anything. Can connect to `offline`, `local`, `global`, and `server` mode.

### Web Interfacce

Web Interface should behave the same as GUI interface. Though differs. A middleman is required just like GUI inteface.

Can connect to `offline`, `local`, `global`, `server`

### Specific Web Interface

Custom Web Interface can be used as opposed to default web interface. Useful for live 'production' server since
it should connect to local unix socket. A bypass can be used than using unix socket.
