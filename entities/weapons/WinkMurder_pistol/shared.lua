//----------------------------------------------
//Author Info
//----------------------------------------------
SWEP.Author             = "ljdp"
SWEP.Contact            = ""
SWEP.Purpose            = ""
SWEP.Instructions       = "-25 health of YOUR health on every shot! Be careful."
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
			--IF THE MURDER SHOOTS
			self:ShootBullet(100,1,0)
		else
			if victim:GetNetworkedInt("WinkMurderer") == 1 then
				--IF AN INNOCENT SHOOTS THE MURDERER
				self:ShootBullet(30,1,0)
			else
				--IF AN INNOCENT SHOOTS AN INNOCENT
				self:ShootBullet(5,1,0)
			end
		end
	else
		self:ShootBullet(1,1,0)
	end
	
	--IF AN INNOCENT SHOOTS
	if SERVER and self.Owner:GetNetworkedInt("WinkMurderer") == 0 then
		local hp = self.Owner:Health()
		hp = hp - 25
		self.Owner:SetHealth(hp)
		if self.Owner:Health() <= 0 then
			self.Owner:Kill()
		end
	end
	
	self.Weapon:EmitSound(ShootSound, 10, 100)
end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
 
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()	// Source
	bullet.Dir 		= self.Owner:GetAimVector()	// Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )		// Aim Cone
	bullet.Tracer	= 1	// Show a tracer on every x bullets 
	bullet.Force	= 1	// Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
 
	self.Owner:FireBullets( bullet )
 
	self:ShootEffects()
 
end
 
 
//--------------------------------------------
// Called when the player Uses secondary attack
//--------------------------------------------
function SWEP:SecondaryAttack()

end
 