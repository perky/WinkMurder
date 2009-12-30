AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

local WinkMurderPlayer

----------------------
-- Round functions. --
----------------------
function GM:CanStartRound( round_number )
	local PlayerList = player.GetAll()
	WinkMurderPlayer = table.Random( PlayerList )
	
	for k,ply in pairs(PlayerList) do
		ply.WinkMurder = false
		ply:SetTeam( TEAM_MAIN )
		ply:Spawn()
		ply:SetNetworkedInt("WinkMurderer",0)
	end
	WinkMurderPlayer.WinkMurder = true
	WinkMurderPlayer:SetNetworkedInt("WinkMurderer",1)
	
	for k,ply in pairs(PlayerList) do
		ply:PrintMessage( HUD_PRINTTALK, WinkMurderPlayer:Nick().." is murderer" )
	end
	return true
end

function GM:OnRoundStart( round_number )
	self.BaseClass:OnRoundStart( round_number )
	
end

function GM:RoundTimerEnd()
	if ( !GAMEMODE:InRound() ) then return end 
	
	GAMEMODE:RoundEndWithResult( WinkMurderPlayer, WinkMurderPlayer:Nick().." fooled you all!" )
end

function GM:OnRoundEnd( round_number )
	self.BaseClass:OnRoundEnd( round_number )
	
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
	player:SetTeam( TEAM_MAIN )
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	self.BaseClass:DoPlayerDeath( ply, attacker, dmginfo )
	
	if ply == WinkMurderPlayer then
		GAMEMODE:RoundEndWithResult( attacker, attacker:Nick().." Wins!" )
	end
end