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

All notes are encrypted by default.

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

#### CLI Interface

CLI Interface brings 5 commands. `list`, `read`, `edit`, `delete`, `trash`.
For `trash`, only 2 sub-commands: `restore`, `purge`.

Edit should bring user's favorite CLI tools like VIm, Emacs, Nano, etc.

Deletion for default to trash. Trash are in /app/data/trash

Can connect to `offline`, `local`, `global`, and `server` mode.

#### GUI Interface

GUI interface may use GTk, TKinter, or anything. Can connect to `offline`, `local`, `global`, and `server` mode.

#### Web Interfacce

Web Interface should behave the same as GUI interface. Though differs. A middleman is required just like GUI inteface.

Can connect to `offline`, `local`, `global`, `server`

#### Specific Web Interface

Custom Web Interface can be used as opposed to default web interface. Useful for live 'production' server since
it should connect to local unix socket. A bypass can be used than using unix socket.

### Make-based install

If modes and interfaces are too much to install, we can use make.
Now, basic make file has been created.

## Informations

### Non-Unix-like compatibility

Systems like Windows are only able to use `offline` and `client` mode.

### Modes

What are these modes anyway?

#### `offline`

`offline` mode is an offline mode that in no way uses either a networking stuff like Unix Socket or TCP/UDP.

#### `local`

Different from `offline`, this mode relies on unix socket.
Its runtime directory is stored in `/run/user/<uid>` which makes it quite incompatible with any non-unix-like systems.

#### `global`

Quite the same as `local` except that it can be used by other users. There are almost no difference from `global` and `server`.
Its runtime directory is stored in `/run`.

#### `server`

`server` mode can either relies on `/run/app-name/sock` or use direct database connection.
This mode should be forcefully available to Linux or Unix-like systems since it requires a different user and private directory.
Feature check against `adduser`, `id`, and `os.name`, `setuid` will determine the availability of `server` mode.
Private directory are stored in `/var/local/data/<app-name>`

#### `client`

`client` mode relies HTTP connection to be able to connect to the server. Nothing is stored in user-space except possible cookies.
But, this only depends on the server you're connecting. The project doesn't actually need to implement this mode since you can connect
to the server from browser.

### Features

What feature can be disabled and enabled?

#### SQLite3

Enabling `sqlite3` brings availability to all (except `client`) modes.
Disabling `sqlite3` only disables `local`, and `server`
Feature checks are done by checking `sqlite` availability in Python stdlib.

#### FSN (File System Notes)

Since SQLite3 and FSN are used to store notes. There's no way you will disable FSN feature when already disabled SQLite3 feature.
Enabling FSN only unlock `offline`.
Disabling FSN only disables `offline`.

#### Encryption

Enabling `encryption` doesn't affect what modes are available.
Disabling `encryption` only disables `global` (not direct `global`) and `server`
Feature checks are done by checking `hmac` availability in Python stdlib.

#### X Interface

You can disable all except 1 interface.

#### X Modes

You can disable all except 1 modes. If by disabling few specific features and resulting to only 1 left, the installation will skip to build process.

### `global` and `server`

The installation requires root privilege to be able to install to `/usr/local` directory,
create new system user (by UID-612), create new private/home directory at `/var/local`,
and install systemd service file.

"What systemd service file does?" create directory at `/var`. This step will be skipped if direct `global` is used.

### Private directories and System User

Suppose a configured user is "secnote" with uid of 612.
The expansion of private directories are:

```
/var/local/data/secnote
/run/secnote
```

Suppose a local installation provide app name with "secnote":

```
/home/<username>/.config/secnote
```

```
C:\Users\<username>\AppData\secnote
C:\Users\<username\.config\secnote
```

The expansions really depends on **HOW** it was installed. For Windows, if installed through Wizard, yes.
The first entry is used. Fallback to `~/.config/secnote` if build from source.

### direct `global`

Direct global disables password-cache if encryption is enabled.

### `global`

Let's hope that parent process UID is helpful to determine who's calling the app.
