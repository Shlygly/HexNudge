hexchat.register('HexNudge', '1.0', 'Wizz & Nudge for hexchat')

NUDGE_SPEED = 60 -- Nudge speed interval
NUDGE_COUNT = 41 -- Nudge count to end (must be n%2 == 1)

Nudge_Index = 0

hexchat.hook_command('NUDGE', function (args)
	if (#args ~= 2) then
		hexchat.print("Utilisation : NUDGE <pseudo>")
	else
		hexchat.command('NOTICE '..args[2]..' WIZZ')
	end
end)

hexchat.hook_command('WIZZ', function (args)
	if (#args ~= 2) then
		hexchat.print("Utilisation : WIZZ <pseudo>")
	else
		hexchat.command('NOTICE '..args[2]..' WIZZ')
	end
end)

hexchat.hook_server('NOTICE', function (args, args_eol)
	if (args_eol[4] == ':WIZZ') then
		DoNudge()
	end
end)

function DoNudge()
	if (Nudge_Index <= 0) then
		Nudge_Index = 0
		hexchat.hook_timer(NUDGE_SPEED, function (args)
			hexchat.command('GUI FLASH')
			hexchat.command('GUI MENU TOGGLE')
			Nudge_Index = Nudge_Index + 1
			if (Nudge_Index > NUDGE_COUNT) then
				Nudge_Index = 0
				return false;
			end
			return true;
		end)
	end
end
