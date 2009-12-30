
local CLASS = {}

CLASS.DisplayName			= "Default Class"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 400
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 300
CLASS.PlayerModel			= "models/player/Kleiner.mdl"
CLASS.DrawTeamRing			= false

function CLASS:Loadout( pl )

	pl:Give( "WinkMurder_pistol" )
	
end

function CLASS:OnSpawn( pl )
	if pl.WinkMurder then
		pl:SetRunSpeed(600)
		pl:SetWalkSpeed(310)
		pl:SetFOV(110,0.6)
	else
		pl:SetRunSpeed(400)
		pl:SetWalkSpeed(300)
		pl:SetFOV(40,0.6)
	end
end

player_class.Register( "Default", CLASS )