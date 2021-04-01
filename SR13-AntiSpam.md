# SR13-AntiSpam
by rowaasr13

* https://www.curseforge.com/wow/addons/sr13-antispam

An anti-spam filter for general, trade, LFG and other built-in channels.

## What it does?
It detects and removes spam from all game's built-in channels. Right now it focuses on boosting spam. In addition to removing detected spam, addon also remembers spammers themselves and removes all their messages from channel until logout or reload.

## How it is different?
This addon employs patterns specially tailored against boost spam, including usual typos and deliberate evasion tactics. Since those messages are within the rules for the moment, it doesn't reports them, but simply removes spam from the chat. Below is comparison with other addons.

* BadBoy - top player in the field - focuses on RMT spammers that explicitly break Blizzard rules and can be reported. Since most of the boost spammers today advertise services for gold, they are technically within the rules and thus BadBoy doesn't target them.
* CCleaner - its plugin - requires you to manually set-up ignored words; prone to false positives, because it removes message for just one word; and despite using some cleaning up features of main addon, has only plain text matching, which is susceptible to evasion and doesn't let you use more complex patterns.

## How to use?
Install and that's all. There's no configuration at the moment.

## What patterns are there?
Right now patterns are collected by monitoring largest English EU servers. Many of them are smart enough to work even in other languages of game.

## Contribution, debug features, etc.

### How to see what is blocked?
There's a hidden debug mode that highlights spam with blue color instead of removing it.

Copy this command into chat:

	/run _G['SR13-AntiSpam'].highlight_spam = true

Be sure to run it early after logging in or reloading interface, because it only shows freshly blocked spam - after spammer is caught specific amount of times all his messages are silently dropped even in this mode. When you done watching, set it back to `false` or reload UI.

### How to report spam?
Feel free to send spam lines not caught on your server. If your server is not English, please mention language. Please do not retype them by hand though, and don't use screenshots either - I need exact copy of spam lines from game to make sure I cover any evasions or other characteristic of the text.

This addon includes a built-in visible chat dumper. Scroll to the spam so it is visible in your chat window and copy this into chat.
	
	/run _G['SR13-AntiSpam'].ChatFrameDump()

Now log out or reload UI to let WoW save results and look for saved file in `(World of Warcraft install location)\_retail_\WTF\Account\(your account)\(your server)\(your character)\SavedVariables\SR13-AntiSpam.lua`. Delete chat lines caught in the dump that are not spam and then send that file to me.
