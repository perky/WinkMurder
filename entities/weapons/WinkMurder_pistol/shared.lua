//----------------------------------------------
//Author Info
//----------------------------------------------
SWEP.Author             = "ljdp"
SWEP.Contact            = ""
SWEP.Purpose            = ""
SWEP.Instructions       = ""
//----------------------------------------------
 
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

// Weapon Details
SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
// Sound
local ShootSound = Sound ("Weapon_Pistol.Single")
 
//--------------------------------------------
// Called when it reloads 
//--------------------------------------------
function SWEP:Reload()

end
 
//--------------------------------------------
// Called each frame when the Swep is active
//--------------------------------------------
function SWEP:Think()
 
end
 
//--------------------------------------------
// Called when the player Shoots
//--------------------------------------------
function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	local victim = nil
	if ( tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
		victim = tr.Entity
	end
	
	if victim then
		if self.Owner:GetNetworkedInt("WinkMurderer") == 1 then
			self:ShootBullet(25,1,0)
		else
			self:ShootBullet(200,1,0)
			if SERVER and victim:GetNetworkedInt("WinkMurderer") == 0 then self.Owner:KillSilent() end
		end
	else
		self:ShootBullet(1,1,0)
	end
	
	self.Weapon:EmitSound(ShootSound, 10, 100)
end
 
 
//--------------------------------------------
// Called when the player Uses secondary attack
//--------------------------------------------
function SWEP:SecondaryAttack()

end
 