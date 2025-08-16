# Tibia 7.4 Game Server
This is the result of manually decompiling the leaked Tibia 7.7 server binary into a readable version of the original source code. With the exception of a few [changes](#changes), expected typos, and translation errors, everything should be as close as possible to the original. I do expect problems so any issues should be submitted to the issue tracker with the appropriate description.

## License and Legal Issues
The legal status of decompiled and rewritten code is a gray area. While the project contains no original assets or code, CipSoft may still view this as a violation of their claimed intellectual property rights, due to the original binary not being willfully released. As the author, I release this code into the public domain, relinquishing all rights and claims to it (see `LICENSE.txt`).

## Changes
- The most important change was fixing thread interations. The original binary relied on some old Linux threading library, most likely LinuxThreads, which assigned different process ids to different threads, among other quirks. The fix is small and contained in commit `d359c0a`.

- Custom RSA routines were replaced with OpenSSL's libcrypto. I didn't bother to translate the decompiled routines because it would be annoying to get write and could end up with security issues. This introduces the **ONLY** dependency required to compile but is fairly simple to get it installed on most Linux distros. For example, on Debian you can use `apt install libssl-dev`.

## Future
I had a small *TODO* list with a few things to attempt after the server was up and running but I think that trying to modernize it further or get it to run on Windows wouldn't really add any value, plus it would probably require a lot of extra time. My commitment is to fix all reported bugs and perhaps string handling/building which is kind of a disaster. Exceptions are already too engraved into the codebase, to the point it would make more sense to rewrite everything without them rather than attempting to remove them.

## Compiling
The server uses a few Linux specific features so it will **ONLY** compile on Linux. It's possible to port to Windows but it would require a few design changes. Originally it would have no dependencies but with the RSA routines change it now requires OpenSSL's `libcrypto` as its **ONLY** dependency. The makefile is very simple and should work as long as libcrypto is installed. You can add the `-j N` switch to make it compile across N processes.
```
make                        # build in release mode
make DEBUG=1                # build in debug mode
make clean                  # remove `build` directory
make clean && make          # full rebuild in release mode (recommended)
make clean && make DEBUG=1  # full rebuild in debug mode   (recommended)
```

## Running
This repository contains only the source code for the game server. After the first decompilation pass, it was clear the server would need a few supporting services. They're fairly simple but each one will have a separate *README* file with a short description on how to compile and run them.
- [Query Manager](https://github.com/fusion32/tibia-querymanager)
- [Login Server](https://github.com/fusion32/tibia-login)
- [Web Server](https://github.com/fusion32/tibia-web)

The game server won't boot up if it's not able to connect to the query manager which makes it the only real hard dependency. The login server will handle character list, and the web server will handle basic account management.

It is recommended that the server is setup as a service. There is a *systemd* configuration file (`tibia-game.service`) in the repository that may be used along with the intructions below to set everything up. The steps may change depending on whether your system uses *systemd* or not.

> It is also a good idea to configure a firewall and generate a new RSA private key for **security** reasons, but those aren't covered here.

## Playing
Playing will require a copy of the original Tibia 7.7 client and some IP-Changer application. Since I can't trust anything out there, I also wrote a small [IP-Changer](https://github.com/fusion32/tibia-ipchanger) command line tool which should be very simple to use. As for the client itself, there is no way except to look around the internet for the old installer and hope that it doesn't contain viruses. It is always a good idea to check it with [Virus Total](https://www.virustotal.com).

### Stale data
The leaked tarball contains a lot of stale data that you may want to cleanup ahead of time:
- `.tibia` contains the base config and should be configured appropriately
- `dat/owners.dat` contains house owner information and will cause query manager errors the first time the server is run because there is no character data in the database
- `log` contains old log data
- `map` contains world data which is **PERSISTENT** and should probably be replaced with a fresh copy of `origmap`
- `map.bak` contains map backup data (generated from `map` by some external tool)
- `usr` contains old character data
- `usr.bak` contains character backup data (generated from `usr` by some external tool)
- `save/game.pid` is used to prevent multiple instances of the game server from running at the same time and will linger if the process doesn't exit gracefully -- should be removed whenever **needed** to allow the server to properly startup

> The server won't create sub-directories like `usr/01` which will result in saving/loading errors. You'll need to recreate them manually with `mkdir -p {00..99}`.

### Prepare game files
```
tar -xzf ./tibia-game.tarball.tar.gz ./tibia-game           # extract game files
cp game ./tibia-game/bin/game                               # replace old game binary with newly compiled one
cp tibia.pem ./tibia-game/tibia.pem                         # copy RSA private key
```

### Setup service user and game files
The default service config will assume game files are in `/opt/tibia/game`.
```
useradd -r -M tibia-game                                    # create user that will run the service
mkdir -p /opt/tibia/game                                    # create directory that will hold game files
cp -r ./tibia-game/* /opt/tibia/game                        # copy game files into /opt/tibia/game
chown -R tibia-game:tibia-game /opt/tibia/game              # change game files ownership to newly created user
```

### Install service
```
cp tibia-game.service /etc/systemd/system                   # copy service configuration into place
systemctl daemon-reload                                     # reload configuration files
systemctl enable tibia-game.service                         # enable service
systemctl start tibia-game.service                          # start service
```

### Check service
```
systemctl status tibia-game.service                         # show service status
journalctl -n 100 -f -u tibia-game.service                  # show last 100 log lines
```

### Ownership and permission problems
Unexpected errors may arise from invalid file ownership and permissions. You should always make sure that game files have the appropriate read-write-execute permissions and that are owned by the user running the game binary. I won't discuss this topic here but you may find plenty of information either in the manual (`man chmod`, `man chown`) or the internet.

> Extra Security: Files with sensitive data like `tibia.pem` should have 0600 permissions to make sure it is only accessed by the assigned user.

## Comparison with OpenTibia
### Performance
The application is well designed and I'd expect the main thread to have comparable performance to OpenTibia distros. The problem is that each connection will spawn a communication thread, each with its own stack (hardcoded to 64KB) and a few extra system resources for bookkeeping. They should have negligible runtime due to constant I/O but if we consider a high volume, CPU performance would surely be impacted with the constant context switching, nevermind the constant instruction and data cache thrashing.

Making connection management asynchronous would probably allow a higher number of connections with better performance but would also require some design changes as the communication threads will also handle authentication which involves reaching out to the query manager which also performs I/O.

### Customizability
If we're talking about the executable itself, then the imagination is the limit. If we're talking about external files/scripts, then you'll find that changes are strictly limited to existing game mechanics. The level of customizability of OpenTibia servers are a lot higher with custom Lua scripts, etc...

Modifying original files shouldn't be too difficult with a text editor but having a specialized tool like a map editor will make a huge difference when trying to modify the map particularly.

## Why
I've been thinking about different server designs lately, and at the start of the year, I had setup a decompilation project for the leaked binary to see if would give me any insights. To my surprise it had debug symbols which made all the difference and kinda got me hooked. I knew I'd want to fully decompile it at some point but mostly for introspection.

I still visit OTLand every once in a while, and around May of this year, there was a thread advertising a server using some modified version of the 7.7 leak, which quickly turned into a shit show. It got me wondering why hadn't anyone released anything related to this leak **AT ALL**, and as the depressing as it may sound, there is only one answer: the OpenTibia **community** is pretty much dead. People gate-keeping or selling features/bug-fixes, abusing known bugs to extort server owners. Entitled users that can't get anything working without help while also extorting players with their low quality servers. A pathetic server list that requires advertisement fees to even display servers past a certain amount of players. It is a dread scenario all across.

To break out of this shitty ass trend, I knew from the beginning that I'd release it all with no strings attached. It may not be in the best possible shape but it will give an idea on how earlier Tibia servers worked and may even serve as inspiration for future server designs.
