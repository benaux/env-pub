set oldclip to the clipboard

tell application "Firefox" to activate
	tell application "System Events"
	keystroke "l" using command down
	keystroke "c" using command down
end tell
delay 0.5

-- return the clipboard
set site to the clipboard

tell application "Iridium"
   activate
   open location site
end tell

set the clipboard to oldclip
