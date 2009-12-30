include( "shared.lua" )

surface.CreateFont( "HUDNumber2", ScreenScale(20), 400, true, true, "WinkMurderFont1" )
local screenColor = 1

function GM:HUDDrawTargetID()
     return false
end

function GM:HUDPaint()
	self.BaseClass:HUDPaint()
	
	local WinkMurderer = LocalPlayer():GetNetworkedInt("WinkMurderer")
	if WinkMurderer == 1 then
		local String = "You are the Wink Murderer"
		draw.SimpleText( String, "WinkMurderFont1", (ScrW()/2), 20, Color(255,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

function GM:RenderScreenspaceEffects()
	self.BaseClass:RenderScreenspaceEffects()
	
	if LocalPlayer():GetNetworkedInt("WinkMurderer") == 1 and screenColor > 0 then
		screenColor = screenColor - 0.01
	end
	
	if LocalPlayer():GetNetworkedInt("WinkMurderer") == 0 and screenColor < 1 then
		screenColor = screenColor + 0.01
	end
	
    local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = screenColor
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
    tab[ "$pp_colour_mulb" ] = 0 
 
    DrawColorModify( tab )
end

local function PreRound( um )
	LocalPlayer():EmitSound(GAMEMODE.Sounds.Whoismole, 60)
end
usermessage.Hook("winkmurder_preround", PreRound)

local function OnRoundStart( um )
	LocalPlayer():EmitSound(GAMEMODE.Sounds.Boom, 60)
end
usermessage.Hook("winkmurder_onroundstart", OnRoundStart)

local function OnRoundEnd( um )
	local b = um:ReadBool()
	if b then
		LocalPlayer():EmitSound(GAMEMODE.Sounds.MurderWin, 60)
	else
		LocalPlayer():EmitSound(GAMEMODE.Sounds.InnocentWin, 60)
	end
end
usermessage.Hook("winkmurder_onroundend", OnRoundEnd)

function GM:UpdateHUD_Observer( bWaitingToSpawn, InRound, ObserveMode, ObserveTarget )
 
        local lbl = nil
        local txt = nil
        local col = Color( 255, 255, 255 );
 
        if ( IsValid( ObserveTarget ) && ObserveTarget:IsPlayer() && ObserveTarget != LocalPlayer() && ObserveMode != OBS_MODE_ROAMING ) then
                lbl = "SPECTATING"
                txt = "?"
                col = team.GetColor( ObserveTarget:Team() );
        end
       
        if ( ObserveMode == OBS_MODE_DEATHCAM || ObserveMode == OBS_MODE_FREEZECAM ) then
                txt = "You Died!" // were killed by?
        end
       
        if ( txt ) then
                local txtLabel = vgui.Create( "DHudElement" );
                txtLabel:SetText( txt )
                if ( lbl ) then txtLabel:SetLabel( lbl ) end
                txtLabel:SetTextColor( col )
               
                GAMEMODE:AddHUDItem( txtLabel, 2 )             
        end
 
       
        GAMEMODE:UpdateHUD_Dead( bWaitingToSpawn, InRound )
 
end

function GM:AddScoreboardKills( ScoreBoard )
    local f = function( ply ) return ply:GetNetworkedInt("wins") end
    ScoreBoard:AddColumn( "Wins", 50, f, 0.5, nil, 6, 6 )
end

function GM:PlayerStartVoice( ply )
	return false
end