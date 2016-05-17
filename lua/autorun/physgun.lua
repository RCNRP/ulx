function FGod( ply, dmginfo )
		if(ply:GetNetworkedVar("FGod") == 1) then
				dmginfo:ScaleDamage( 0 )
		end
end
hook.Add("EntityTakeDamage", "FGod", FGod)

hook.Add("PhysgunDrop", "ply_physgunfreeze", function(pl, ent)
	hook.Remove( "PhysgunDrop", "ulxPlayerDrop" ) --This hook from ULX seems to break this script that's why we are removing it here.
	
	ent._physgunned = false
	
	if( ent:IsPlayer() && ( pl:IsUserGroup( "superadmin" ) or pl:IsUserGroup( "admin" )) ) then     --If you want to insert another one insert "or pl:IsUserGroup( "YetAnotherGroup" )"    		   
		-- predicted?
		
		if(pl:KeyDown(IN_ATTACK2)) then
			ent:Freeze(true)
			ent:SetNetworkedVar("FGod", 1)
			ent:SetMoveType(MOVETYPE_NOCLIP)
		else
			ent:Freeze(false)
			ent:SetNetworkedVar("FGod", 0)
			ent:SetMoveType(MOVETYPE_WALK)
		end



		if SERVER then
			-- NO UUUU FKR
			if !ent:Alive() then
				ent:Spawn()
				self:PlayerSpawn(ent)
				ent:SetPos(pl:GetEyeTrace().HitPos)
			end
		end
		
	else -- If it wasn't an admin in your defined groups then don't do anything
			ent:Freeze(false)
			ent:SetNetworkedVar("FGod", 0)
			ent:SetMoveType(MOVETYPE_WALK)

		return --self.BaseClass:PhysgunDrop( pl , ent )    
	end
end)

hook.Add( "PhysgunPickup", "ply_physgunned", function(pl, ent)
	ent._physgunned = true
end)

function playerDies( pl, weapon, killer )
	if(pl._physgunned) then
		return false
	else
		return true
	end
end
hook.Add( "CanPlayerSuicide", "playerNoDeath", playerDies )
