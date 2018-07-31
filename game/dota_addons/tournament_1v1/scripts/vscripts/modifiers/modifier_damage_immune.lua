modifier_damage_immune = class({})

function modifier_damage_immune:IsHidden()
	return true
end

function modifier_damage_immune:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function modifier_damage_immune:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_damage_immune:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_damage_immune:GetAbsoluteNoDamagePure()
	return 1
end
