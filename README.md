# ShaguScan

<img src="./screenshots/raidtargets.jpg" float="right" align="right">

An addon that scans for nearby units and filters them by custom attributes.
It's made for World of Warcraft: Vanilla (1.12.1) and is only tested on [Turtle WoW](https://turtle-wow.org/). It can be used to see all marked raid targets, detect rare mobs, find nearby players that decided to do pvp, and much more!

> [!IMPORTANT]
>
> **This addon requires you to have [SuperWoW](https://github.com/balakethelock/SuperWoW) installed.**
>
> It won't work without it. Really.

## Installation (Vanilla, 1.12)
1. Download **[Latest Version](https://github.com/shagu/ShaguScan/archive/master.zip)**
2. Unpack the Zip file
3. Rename the folder "ShaguScan-master" to "ShaguScan"
4. Copy "ShaguScan" into Wow-Directory\Interface\AddOns
5. Restart Wow

# Usage

Multiple windows can be created that each show health bars of nearby units based on custom filters. A new window with the title "Alliance PvP" can be created by typing `/scan Alliance PvP`. A configuration will appear, in which the created window can be customized. You can chose as many filters as you wish (comma separated).

In case `/scan` is already blocked by another addon, you can also use `/sscan` or `/shaguscan`.

As a filter you could for example choose: `player,pvp,alliance,alive` to only show players with pvp enabled on the alliance side that are alive.

You can build the lists as you want them, there are now limits as long as the filter for it exists.

![config](./screenshots/config.jpg)

# Filters

<img src="./screenshots/infight.jpg" float="right" align="right">

- **player**: all player characters
- **npc**: all non-player characters
- **infight**: only units that are in combat
- **dead**: only dead units
- **alive**: only alive units
- **horde**: only horde units
- **alliance**: only alliance units
- **hardcore**: only hardcore enabled players
- **pve**: only pve-flagged units
- **pvp**: only pvp-flagged units
- **icon**: only units with an assigned raid icon
- **normal**: only units of type "normal" (no elite, rare, etc.)
- **elite**: only units of type "elite" or "rareelite"
- **rare**: only units of type "rare" or "rareelite"
- **rareelite**: only units of type "rareelite"
- **worldboss**: only units of type "worldboss"

New filters are easy to implement, if you wish to create your own, please have a look at: [filter.lua](./filter.lua).