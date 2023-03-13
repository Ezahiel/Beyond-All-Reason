function widget:GetInfo()
	return {
		name	= "Pos Reader / Metal Pos Generator",
		desc	= "Read pos on mouse click & generate metal pos on metal maps",
		author	= "wilkubyk",
		date	= "March, 2023",
		license	= "GNU GPL, v2 or later",
		layer	= 0,
		enabled = false,
	}
end

local GetMouseState = Spring.GetMouseState
local TraceScreenRay = Spring.TraceScreenRay

local lastx, lastz = 0, 0
local posTable = {}
local abs				= math.abs

function gadget:MousePress(x,y,button)
    if button == 2 then
        return
    end

    local mx,my = GetMouseState()
    local _,pos = TraceScreenRay(mx,my,true)

    if not pos then
        return
    end

    if abs(pos[1] - lastx) > 300 or abs(pos[3] - lastz) > 300 then
        table.insert(posTable, {pos[1], pos[3]})
        Spring.Echo("position x =  ", pos[1], "position z =  ", pos[3])
        lastx, lastz = pos[1], pos[3]
    end
end

local function maybeRemoveSelf()
	if Spring.GetSpectatingState() then
		widgetHandler:RemoveWidget()
	end
end

function widget:Initialize()
    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
        maybeRemoveSelf()
    end
end

function widget:PlayerChanged(playerID)
    maybeRemoveSelf()
end
--[[
function addon.MousePress(...)
	--Spring.Echo(...)
end



function gadgetHandler:MousePress(x, y, button)
	local mo = self.mouseOwner
	if mo then
		mo:MousePress(x, y, button)
		return true  --  already have an active press
	end
	for _, g in ipairs(self.MousePressList) do
		if g:MousePress(x, y, button) then
			self.mouseOwner = g
			return true
		end
	end
	return false
end

]]--