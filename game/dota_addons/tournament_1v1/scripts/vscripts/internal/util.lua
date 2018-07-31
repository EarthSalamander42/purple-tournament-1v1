function DebugPrint(...)
	local spew = Convars:GetInt('barebones_spew') or -1
	if spew == -1 and BAREBONES_DEBUG_SPEW then
		spew = 1
	end

	if spew == 1 then
		print(...)
	end
end

function DebugPrintTable(...)
	local spew = Convars:GetInt('barebones_spew') or -1
	if spew == -1 and BAREBONES_DEBUG_SPEW then
		spew = 1
	end

	if spew == 1 then
		PrintTable(...)
	end
end

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end

	done = done or {}
	done[t] = true
	indent = indent or 0

	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end

	table.sort(l)
	for k, v in ipairs(l) do
		-- Ignore FDesc
		if v ~= 'FDesc' then
			local value = t[v]

			if type(value) == "table" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..":")
				PrintTable (value, indent + 2, done)
			elseif type(value) == "userdata" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
			else
				if t.FDesc and t.FDesc[v] then
					print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
				else
					print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				end
			end
		end
	end
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'

function DebugAllCalls()
	if not GameRules.DebugCalls then
		print("Starting DebugCalls")
		GameRules.DebugCalls = true

		debug.sethook(function(...)
			local info = debug.getinfo(2)
			local src = tostring(info.short_src)
			local name = tostring(info.name)
			if name ~= "__index" then
				print("Call: ".. src .. " -- " .. name .. " -- " .. info.currentline)
			end
		end, "c")
	else
		print("Stopped DebugCalls")
		GameRules.DebugCalls = false
		debug.sethook(nil, "c")
	end
end

--[[Author: Noya
	Date: 09.08.2015.
	Hides all dem hats
]]
function HideWearables( unit )
	unit.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
	local model = unit:FirstMoveChild()
	while model ~= nil do
		if model:GetClassname() == "dota_item_wearable" then
			model:AddEffects(EF_NODRAW) -- Set model hidden
			table.insert(unit.hiddenWearables, model)
		end
		model = model:NextMovePeer()
	end
end

--[[Author: Noya
	Date: 09.08.2015.
	Show all dem hats
]]
function ShowWearables( unit )
	for i,v in pairs(unit.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
	end
end

-- Thanks to LoD-Redux & darklord for this!
function DisplayError(playerID, message)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message=message})
	end
end

-- Make tower tier 1 invulnerable
function MakeT1Invulnerable()
	local towers = Entities:FindAllByClassname("npc_dota_tower")

	for _, tower in pairs(towers) do
		if string.find(tower:GetUnitName(), "tower1") then
			tower:AddNewModifier(tower, nil, "modifier_damage_immune", {})
		end
	end
end

-- Remove top and bottom lanes creeps
function RemoveSideLanes()
	local removed_ents = {
		"lane_top_goodguys_melee_spawner",
		"lane_bot_goodguys_melee_spawner",
		"lane_top_badguys_melee_spawner",
		"lane_bot_badguys_melee_spawner",
	}

	for _, ent_name in pairs(removed_ents) do
		local ent = Entities:FindByName(nil, ent_name)
		ent:RemoveSelf()
	end
end

-- Block jungle creep camps using a dummy unit
function BlockJungleCamps()
	local blocked_camps = {}
	blocked_camps[1] = {"neutralcamp_evil_1", Vector(-4170, 3670, 512)}
	blocked_camps[2] = {"neutralcamp_evil_2", Vector(-3030, 4500, 512)}
	blocked_camps[3] = {"neutralcamp_evil_3", Vector(-2000, 4220, 384)}
	blocked_camps[4] = {"neutralcamp_evil_4", Vector(-10, 3300, 512)}
	blocked_camps[5] = {"neutralcamp_evil_5", Vector(1315, 3520, 512)}
	blocked_camps[6] = {"neutralcamp_evil_6", Vector(-675, 2280, 1151)}
	blocked_camps[7] = {"neutralcamp_evil_7", Vector(2400, 360, 520)}
	blocked_camps[8] = {"neutralcamp_evil_8", Vector(4060, -620, 384)}
	blocked_camps[9] = {"neutralcamp_evil_9", Vector(4100, 1050, 1288)}
	blocked_camps[10] = {"neutralcamp_good_1", Vector(3010, -4430, 512)}
	blocked_camps[11] = {"neutralcamp_good_2", Vector(4810, -4200, 512)}
	blocked_camps[12] = {"neutralcamp_good_3", Vector(787, -4500, 512)}
	blocked_camps[13] = {"neutralcamp_good_4", Vector(-430, -3100, 384)}
	blocked_camps[14] = {"neutralcamp_good_5", Vector(-1500, -4290, 384)}
	blocked_camps[15] = {"neutralcamp_good_6", Vector(-3040, 100, 512)}
	blocked_camps[16] = {"neutralcamp_good_7", Vector(-3700, 890, 512)}
	blocked_camps[17] = {"neutralcamp_good_8", Vector(-4780, -190, 512)}
	blocked_camps[18] = {"neutralcamp_good_9", Vector(256, -1717, 1280)}

	for i = 1, #blocked_camps do
		local ent = Entities:FindByName(nil, blocked_camps[i][1])
		local dummy = CreateUnitByName("npc_dummy_unit", blocked_camps[i][2], true, nil, nil, DOTA_TEAM_NEUTRALS)
	end
end

function SpawnCourier(hero)
	-- choose the spawn point based on the hero team
	local spawn_point = Entities:FindByClassname(nil, "info_courier_spawn_radiant")
	if hero:GetTeamNumber() == 3 then
		spawn_point = Entities:FindByClassname(nil, "info_courier_spawn_dire")
	end

	-- spawn the courier
	local courier = CreateUnitByName("npc_dota_courier", spawn_point:GetAbsOrigin(), true, nil, nil, hero:GetTeamNumber())

	-- set the courier controllable by a hero
	courier:SetControllableByPlayer(hero:GetPlayerID(), true)
end
