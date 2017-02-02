hexchat.register('HexNudge', '1.1', 'Wizz & Nudge for hexchat')

NUDGE_SPEED = 60 -- Nudge speed interval
NUDGE_COUNT = 31 -- Nudge count to end (must be n%2 == 1)

Nudge_Index = 0

Prefs =
{
	hexnudge_muted=false,
	hexnudge_menublink=true,
	hexnudge_windowblink=false
}

for key,value in pairs(Prefs) do
	if (hexchat.pluginprefs[key] == nil) then
		hexchat.pluginprefs[key] = (value and "ON" or "OFF")
	end
end

hexchat.hook_command('NUDGE', function (args)
	if (#args ~= 2) then
		hexchat.print("Utilisation : NUDGE <pseudo>")
	else
		hexchat.command('NOTICE '..args[2]..' WIZZ')
		DoNudge()
	end
end)

hexchat.hook_command('WIZZ', function (args)
	if (#args ~= 2) then
		hexchat.print("Utilisation : WIZZ <pseudo>")
	else
		hexchat.command('NOTICE '..args[2]..' WIZZ')
		DoNudge()
	end
end)

hexchat.hook_server('NOTICE', function (args, args_eol)
	if (args_eol[4] == ':WIZZ') then
		DoNudge()
	end
end)

function DoNudge()
	if (not GetPref("hexnudge_muted") and Nudge_Index <= 0) then
		Nudge_Index = 0
		hexchat.hook_timer(NUDGE_SPEED, function (args)
			hexchat.command('GUI FOCUS')
			hexchat.command('GUI FLASH')
			if (GetPref("hexnudge_menublink")) then
				hexchat.command('GUI MENU TOGGLE')
			end
			if (GetPref("hexnudge_windowblink")) then
				if (Nudge_Index % 2 == 0) then
					hexchat.command('GUI HIDE')
				else
					hexchat.command('GUI SHOW')
				end
			end
			Nudge_Index = Nudge_Index + 1
			if (Nudge_Index > NUDGE_COUNT) then
				Nudge_Index = 0
				return false;
			end
			return true;
		end)
	end
end

function GetPref(pref)
	if (hexchat.pluginprefs[pref] == "ON") then
		return true
	elseif (hexchat.pluginprefs[pref] == "OFF") then
		return false
	else
		return hexchat.pluginprefs[pref]
	end
end
