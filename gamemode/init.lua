AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

resource.AddFile("sound/winkmurder/murderwin.wav")
resource.AddFile("sound/winkmurder/innocentwin.wav")
resource.AddFile("sound/winkmurder/whoismole.wav")
resource.AddFile("sound/winkmurder/boom.wav")
local WinkMurderPlayer

----------------------
-- Round functions. --
----------------------
function GM:CanStartRound( round_number )
	if #player.GetAll() >= 3 then
		return true
	else
		return false
	end
end

function GM:OnPreRoundStart( round_number )
	local PlayerList = player.GetAll()
	WinkMurderPlayer = table.Random( PlayerList )
	
	for k,ply in pairs(PlayerList) do
		ply.WinkMurder = false
		ply:SetNetworkedInt("WinkMurderer",0)
	end
	WinkMurderPlayer.WinkMurder = true
	WinkMurderPlayer:SetNetworkedInt("WinkMurderer",1)
	
	local rp = RecipientFilter()     
	rp:AddAllPlayers()
	umsg.Start("winkmurder_preround", rp)
	umsg.End()
	
	self.BaseClass:OnPreRoundStart( round_number )
end

function GM:OnRoundStart( round_number )
	self.BaseClass:OnRoundStart( round_number )
	
	local rp = RecipientFilter()     
	rp:AddAllPlayers()
	umsg.Start("winkmurder_onroundstart", rp)
	umsg.End()
end

function GM:RoundTimerEnd()
	if ( !GAMEMODE:InRound() ) then return end 
	
	GAMEMODE:RoundEndWithResult( -1, "Innocent win!" )
end

function GM:OnRoundEnd( round_number )
	self.BaseClass:OnRoundEnd( round_number )
	
	local winner = GetGlobalEntity("RoundWinner")
	local wins = winner:GetNetworkedInt("wins",-1)
	if wins ~= -1 then
		wins = wins + 1
		winner:SetNetworkedInt("wins", wins)
	end
	
	local b
	if winner == WinkMurderPlayer then
		b = true
	else
		b = false
	end
	
	local rp = RecipientFilter()     
	rp:AddAllPlayers()
	umsg.Start("winkmurder_onroundend", rp)
		umsg.Bool( b )
	umsg.End()
end

function GM:CheckPlayerDeathRoundEnd()
end

function GM:CheckRoundEnd()
	local aliveCount = 0
	for k,ply in pairs(player.GetAll()) do
		if ply:Alive() then
			aliveCount = aliveCount + 1
		end
	end
	
	if aliveCount <= 2 then
		GAMEMODE:RoundEndWithResult( WinkMurderPlayer, WinkMurderPlayer:Nick().." fooled you all!" )
	end
end

-----------------------
-- Player functions. --
-----------------------
function GM:PlayerInitialSpawn( player )
	self.BaseClass:PlayerInitialSpawn( player )

	player:SetNetworkedInt("WinkMurderer",0)
	player:SetNetworkedInt("Wins",0)
end

function GM:PlayerDisconnected( pl )
	if pl == WinkMurderPlayer then
		local arr = {}
		for k,ply in pairs(player.GetAll()) do
			if ply ~= pl then
				table.insert(arr,ply)
			end
		end
	
		WinkMurderPlayer = table.Random( arr )
		WinkMurderPlayer.WinkMurder = true
		WinkMurderPlayer:SetNetworkedInt("WinkMurderer",1)
	end
	
	self.BaseClass:PlayerDisconnected( pl )
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	self.BaseClass:DoPlayerDeath( ply, attacker, dmginfo )
	
	if ply == WinkMurderPlayer then
		GAMEMODE:RoundEndWithResult( attacker, attacker:Nick().." Wins!" )
	end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
 
    // More damage if we're shot in the head
    if ( hitgroup == HITGROUP_HEAD ) then
        dmginfo:ScaleDamage( 1 )
	end
         
    // Less damage if we're shot in the arms or legs
    if ( hitgroup == HITGROUP_LEFTARM ||
		hitgroup == HITGROUP_RIGHTARM ||
		hitgroup == HITGROUP_LEFTLEG ||
		hitgroup == HITGROUP_LEFTLEG ||
		hitgroup == HITGROUP_GEAR ) then
			dmginfo:ScaleDamage( 1 )
	end
 
end