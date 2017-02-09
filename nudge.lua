hexchat.register('HexNudge', '1.1', 'Wizz & Nudge for hexchat')

Nudge_Index = 0

-- Preferences init --
Prefs =
{
	hexnudge_muted=false,
	hexnudge_menublink=true,
	hexnudge_windowblink=false,
	hexnudge_nudge_speed = 60,
	hexnudge_nudge_count = 15
}
PrefsMenu =
{
	hexnudge_muted="Activer - Désactiver les wizz",
	hexnudge_menublink="Activer - Désactiver le clignotement du menu",
	hexnudge_windowblink="Activer - Désactiver le clignotement de la fenêtre"
}
for key,value in pairs(Prefs) do
	if (hexchat.pluginprefs[key] == nil) then
		if (type(value) == "boolean") then
			hexchat.pluginprefs[key] = (value and "ON" or "OFF")
		else
			hexchat.pluginprefs[key] = value
		end
	end
end
hexchat.command('MENU DEL "Settings/HexNudge"')
hexchat.command('MENU ADD "Settings/HexNudge"')
for key,value in pairs(PrefsMenu) do
	hexchat.command('MENU DEL "Settings/HexNudge/'..value..'" "WZREV '..key..'"')
	hexchat.command('MENU ADD "Settings/HexNudge/'..value..'" "WZREV '..key..'"')
end

-- NUDGE & WIZZ Commands --
hexchat.hook_command('NUDGE', function (args)
	if (#args ~= 2) then
		hexchat.print("Utilisation : NUDGE <pseudo>")
	else
		hexchat.command('NOTICE '..args[2]..' WIZZ')
		DoNudge()
	end
	return hexchat.EAT_ALL
end)

hexchat.hook_command('WIZZ', function (args)
	if (#args ~= 2) then
		hexchat.print("Utilisation : WIZZ <pseudo>")
	else
		hexchat.command('NOTICE '..args[2]..' WIZZ')
		DoNudge()
	end
	return hexchat.EAT_ALL
end)

-- Preferences Settings Command --
hexchat.hook_command('WZSET', function (args)
	if (#args == 1) then
		for key,value in pairs(hexchat.pluginprefs) do
			hexchat.print(key.." = "..value)
		end
	elseif (#args == 3) then
		if (hexchat.pluginprefs[args[2]] ~= nil) then
			hexchat.pluginprefs[args[2]] = args[3]
		else
			hexchat.print("Variable inconnu")
		end
	else
		hexchat.print("Utilisation : WZSET [<variable> <valeur>]")
	end
	return hexchat.EAT_ALL
end)

hexchat.hook_command('WZREV', function (args)
	if (#args == 2) then
		if (hexchat.pluginprefs[args[2]] == nil) then
			hexchat.print("Variable inconnu")
		elseif (type(GetPref(args[2])) ~= "boolean") then
			hexchat.print("Variable irreversible")
		else
			hexchat.pluginprefs[args[2]] = (GetPref(args[2]) and "OFF" or "ON")
		end
	else
		hexchat.print("Utilisation : WZREV <variable>")
	end
	return hexchat.EAT_ALL
end)

-- NUDGE & WIZZ Button --
hexchat.hook_print('Open Context', function (args)
	hexchat.command('DELBUTTON "Wizz" WIZZ %s')
	hexchat.command('ADDBUTTON "Wizz" WIZZ %s')
end)

-- NUDGE & WIZZ Reception --
hexchat.hook_server('NOTICE', function (args, args_eol)
	if (args_eol[4] == ':WIZZ') then
		DoNudge()
	end
end)

-- Do a Nudge --
function DoNudge()
	if (not GetPref("hexnudge_muted") and Nudge_Index <= 0) then
		Nudge_Index = 0
		hexchat.hook_timer(GetPref("hexnudge_nudge_speed"), function (args)
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
			if (Nudge_Index > GetPref("hexnudge_nudge_count") * 2 + 1) then
				Nudge_Index = 0
				return false;
			end
			return true;
		end)
	end
end

-- Utilities --
function GetPref(pref)
	if (hexchat.pluginprefs[pref] == "ON") then
		return true
	elseif (hexchat.pluginprefs[pref] == "OFF") then
		return false
	else
		return hexchat.pluginprefs[pref]
	end
end
