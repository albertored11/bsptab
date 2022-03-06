# bsptab

![AUR license](https://img.shields.io/aur/license/bsptab-git) ![AUR version](https://img.shields.io/aur/version/bsptab-git)

bsptab is a collection of bash scripts for integrating [tabbed](https://tools.suckless.org/tabbed/),
a tool from [suckless](https://suckless.org/) to create tabbed containers in X environments, into
[bspwm](https://github.com/baskerville/bspwm), a tiling window manager based on binary space
partitioning.

bspwm is an awesome WM, but it only does its job, which does it well: managing windows. However,
bspwm is also extremely scriptable! With these scripts, you can easily organize windows into tabs,
which is a really useful feature for many workflows.

This project is based on [Bachhofer/tabc](https://github.com/Bachhofer/tabc).

Please open an issue/pull request if you find any kind of bug, if you'd like to see any new features, or
especially if you think any part of the code should be rewritten in a better way, since I am not
a bash expert at all.

## Features

* Adds tabbed layouts to bspwm.
* Each tabbed container handles multiple windows, but not any more tabbed containers.
* Automatically attach new windows to tabbed containers.
* Only external scripts, doesn't modify original tabbed code.

## Dependencies

* `bspwm`
* `tabbed`
* `bash`
* `coreutils`
* `awk`
* `xwininfo`
* `xprop`
* `xdotool`

### Tabbed recommendations

* Use [tabbed-flexipatch](https://github.com/bakkeby/tabbed-flexipatch), a tabbed version that uses
  preprocessor directives to include patches, so you can easily select your favorite ones.
* In `config.h`, set the following option:
```c
static int newposition = -1; // attach new windows at the end
```
* Also in `config.h`, configure each setting according to your preferences (e. g. appearance,
  keybindings...), and comment out keybindings for the following functions: `focusonce`, `spawn`,
  `killclient`, `fullscreen`.

#### Required

* In `config.h`, set the following keybindings, which let you switch between tabs using Alt+[Tab#].
  This is important because the `detach()` function in `tabc` uses `xdotool` to perform these key
  combinations (if you prefer, you can also manually edit those lines in the script to match your
  keybindings):
```c
	{ Mod1Mask,             XK_1,         move,        { .i = 0 } },
	{ Mod1Mask,             XK_2,         move,        { .i = 1 } },
	{ Mod1Mask,             XK_3,         move,        { .i = 2 } },
	{ Mod1Mask,             XK_4,         move,        { .i = 3 } },
	{ Mod1Mask,             XK_5,         move,        { .i = 4 } },
	{ Mod1Mask,             XK_6,         move,        { .i = 5 } },
	{ Mod1Mask,             XK_7,         move,        { .i = 6 } },
	{ Mod1Mask,             XK_8,         move,        { .i = 7 } },
	{ Mod1Mask,             XK_9,         move,        { .i = 8 } },
	{ Mod1Mask,             XK_0,         move,        { .i = 9 } }
```
inside
```c
static Key keys[] = {
// ...
};
```

## Installation

<a href="https://repology.org/project/bsptab/versions">
    <img src="https://repology.org/badge/vertical-allrepos/bsptab.svg" alt="Packaging status" align="right">
</a>

Just clone the repo and run `make install` inside the repo directory.

If you are using a pacman-based distro (Arch, Manjaro...), you can use [the AUR package](https://aur.archlinux.org/packages/bsptab-git/) (if you like it, please leave a vote 😁).
And, for debian or ubuntu or distros based on them, checkout [MPR](https://mpr.makedeb.org/packages/bsptab-git)

## Usage

### tabc

This script is used to manage tabbed containers (creating, attaching/detaching windows and toggling
autoattach feature), as well as to launch helper daemons.

Run `tabc <command>`.

Available commands:

* `create <wid>` Create a tabbed container and add window `<wid>`. If `<wid>` is a tabbed container,
  don't do anything. Also enable autoattaching new windows.
* `attach <wid0> <wid1>` Attach window `<wid0>` to tabbed container `<wid1>`. If `<wid0>` is a
  tabbed container, detach the active window and attach it to the new container. If `<wid1>` is not
  a tabbed container, call `create <wid1>` first.
* `detach <wid>` Detach active window from tabbed container `<wid>`. If `<wid>` is not a tabbed
  container, don't do anything.
* `autoattach <wid>` Toggle autoattach new windows to tabbed container `<wid>`. If `<wid>` is not a
  tabbed container, don't do anything.
* `autod <classes>` Launch a daemon that creates a tabbed container for every new window which class
  is in `<classes>`. This can be useful, for example, for file managers, so it and the opened file
  share a tabbed layout. It could be a good idea to include this command in your `bspwmrc`.
* `refreshd` Launch a daemon that does its job as a workaround for a bug that makes the tab
  bar width not to be correctly adjusted sometimes when the size of the tabbed container changes.
  It could be a good idea to include this command in your `bspwmrc`.
* `printclass <wid>` Print class of window `<wid>`.

### tabbed-sub, tabbed-unsub

These two scripts are used to enable autoattach feature for tabbed containers. This means that, when
a new window is added from the container (in bspwm terms, when a new window is the brother of the
container), it is automatically attached to it.

You can use them running `tabbed-sub <wid> &; tabbed-unsub <wid> &`, but you won't probably need it
since they are called from related `tabc` commands.

## Keybindings

It is really useful to run `tabc` script through user-defined keybindings, so you can create tabbed
containers, attach/detach windows to them and toggle autoattach feature just using your keyboard.

### Example keybindings for sxhkd

Add the following lines to your `sxhkdrc`:

```
# add to tabbed container
ctrl + alt + {Left,Down,Up,Right}
    tabc attach $(bspc query -N -n) {$(bspc query -N -n west),$(bspc query -N -n south),$(bspc query -N -n north),$(bspc query -N -n east)}

# create/remove from tabbed container
super + z 
    id=$(bspc query -N -n); \
    [[ "$(tabc printclass $id)" == "tabbed" ]] \
    && tabc detach $id \
    || tabc create $id 

# toggle autoattach in tabbed container
super + shift + z 
    tabc autoattach $(bspc query -N -n) 
```

## Demos

* `tabc create` command

![tabc create command](https://raw.githubusercontent.com/albertored11/albertored11.github.io/main/assets/img/bsptab-demos/bsptab-create.gif)

Open a Chromium window, create a tabbed container using a keyboard shortcut and open new windows as
tabs.

* `tabc attach` command

![tabc attach command](https://raw.githubusercontent.com/albertored11/albertored11.github.io/main/assets/img/bsptab-demos/bsptab-attach.gif)

Attach window (right) to a tabbed container (left) using a keyboard shortcut.

* `tabc detach` command

![tabc detach command](https://raw.githubusercontent.com/albertored11/albertored11.github.io/main/assets/img/bsptab-demos/bsptab-detach.gif)

Detach a couple of windows from a tabbed container and then combine them to create a new container
(again, using keyboard shortcuts).

* `tabc autoattach` command

![tabc autoattach command](https://raw.githubusercontent.com/albertored11/albertored11.github.io/main/assets/img/bsptab-demos/bsptab-autoattach.gif)

Toggle autoattach function using a keyboard shortcut: first, it is enabled, so new windows appear as
tabs; then, it is disabled, so new windows are placed as usual

* `tabc autod` command

![tabc autod command](https://raw.githubusercontent.com/albertored11/albertored11.github.io/main/assets/img/bsptab-demos/bsptab-tabbed-auto.gif)


Open an instance of pcmanfm-qt, and a tabbed container is automatically created, so every new window
opened is added as a tab.

## TODO

* [x] Somehow fix a bug that makes the tab order to mess up when detaching a window.
* [ ] Put everything in a single file.
* [ ] ~~When detaching a window, focus next tab to detached (prev tab if it was the last one).~~
* [ ] ~~Move common functions to a separate script file.~~
