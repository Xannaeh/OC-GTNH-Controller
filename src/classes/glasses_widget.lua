-- src/classes/glasses_widget.lua
local GlassesWidget = {}
GlassesWidget.__index = GlassesWidget

function GlassesWidget:new(id, glassesProxy)
    local obj = setmetatable({}, self)
    obj.id = id
    obj.glasses = glassesProxy
    obj.elements = {}
    return obj
end

function GlassesWidget:addElement(element)
    table.insert(self.elements, element)
end

function GlassesWidget:render()
    for _, element in ipairs(self.elements) do
        element:draw()
    end
end

function GlassesWidget:clear()
    for _, element in ipairs(self.elements) do
        element:remove()
    end
    self.elements = {}
end

return GlassesWidget
