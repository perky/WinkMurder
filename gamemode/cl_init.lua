include( "shared.lua" )

surface.CreateFont( "HUDNumber2", ScreenScale(20), 400, true, true, "WinkMurderFont1" )

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