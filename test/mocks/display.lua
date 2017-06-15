-- (C) Copyright 2013 Cluain Krystian Szczęsny (http://it.cluain.pl) and others.
--
-- All rights reserved. This program and the accompanying materials
-- are made available under the terms of the GNU Lesser General Public License
-- (LGPL) version 2.1 which accompanies this distribution, and is available at
-- http://www.gnu.org/licenses/lgpl-2.1.html
--
-- This library is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- Lesser General Public License for more details.
--
-- User: Krystian Szczęsny
-- Date: 10/15/13
-- Time: 9:02 AM
--

local display

local function newDisplayObject()
    local _displayObject = {
        alpha = 1,
        blendMode = "normal",
        contentBounds = { xMin = 0, yMin = 0, xMax = 0, yMax = 0 },
        isHitTestMasked = false,
        isHitTestable = true,
        isVisible = true,
        maskRotation = 0,
        maskScaleX = 1,
        maskScaleY = 1,
        maskX = 0,
        maskY = 0,
        parent = nil,
        rotation = 0,
        x = 0,
        xOrigin = 0,
        xReference = 0,
        xScale = 1,
        y = 0,
        yOrigin = 0,
        yReference = 0,
        yScale = 1,
        referencePoint = display.TopLeftReferencePoint,
        eventListeners = {},
        onCompleteCounts = 1 --- cherry default transition testing: calling onComplete once
    }

    _displayObject.setFillColor = function() return  end
    _displayObject.setStrokeColor = function() return  end
    _displayObject.contentHeight = function()
        return _displayObject.contentBounds.yMax - _displayObject.contentBounds.yMin
    end
    _displayObject.contentWidth = function()
        return _displayObject.contentBounds.xMax - _displayObject.contentBounds.xMin
    end
    _displayObject.width = _displayObject.contentWidth()
    _displayObject.height = _displayObject.contentHeight()
    _displayObject.contentToLocal = function(self, x, y) return x - _displayObject.x, y - _displayObject.y end
    _displayObject.localToContent = function(self, x, y) assert(false, "not implemented in mock!") end
    _displayObject.removeSelf = function() _displayObject = {} end
    _displayObject.rotate = function(self, rotation) _displayObject.rotation = _displayObject.rotation + rotation end
    _displayObject.scale = function(self, xScale, yScale)
        _displayObject.xScale = _displayObject.xScale * xScale _displayObject.yScale = _displayObject.yScale * yScale
    end
    _displayObject.setMask = function(self, mask) _displayObject.mask = mask end
    _displayObject.setReferencePoint = function(self, referencePoint) _displayObject.referencePoint = referencePoint end
    _displayObject.toBack = function() end
    _displayObject.toFront = function()
        assert(_displayObject.parent, "no parent set!")
        local c = _displayObject.parent:remove(_displayObject)
        table.insert(c, _displayObject)
    end
    _displayObject.translate = function(x, y)
        _displayObject.x = _displayObject.x + x
        _displayObject.y = _displayObject.y + y
    end
    _displayObject.addEventListener = function(self, name, callback)
        if not _displayObject.eventListeners[name] then _displayObject.eventListeners[name] = {} end
        table.insert(_displayObject.eventListeners[name], callback)
    end
    _displayObject.removeEventListener = function(self, name, callback)
        assert(_displayObject.eventListeners[name], "no such event name: " .. tostring(name))
        for i = #_displayObject.eventListeners[name], 1, -1 do
            if _displayObject.eventListeners[name][i] == callback then
                table.remove(_displayObject.eventListeners[name], i)
            end
        end
    end
    _displayObject.dispatchEvent = function(self, event)
        assert(event.name, "event name not provided")
        local listener = _displayObject.eventListeners[event.name]
        if not listener or #listener == 0 then return end

        for i = 1, #listener do
            listener[i](event)
        end
    end

    local displayObject = {}
    local metatable = {
        -- table[key] is accessed
        __index = function(t, key)
            if key == "raw" then
                return _displayObject
            end
            if key == "contentWidth" then
                return _displayObject.contentBounds.xMax - _displayObject.contentBounds.xMin
            elseif key == "contentHeight" then
                return _displayObject.contentBounds.yMax - _displayObject.contentBounds.yMin
            elseif key ~= "content" then
                return _displayObject[key]
            end
        end,
        __newindex = function(t, key, value)
            if key == "x" then
                if _displayObject.referencePoint == display.TopLeftReferencePoint
                    or _displayObject.referencePoint == display.CenterLeftReferencePoint
                    or _displayObject.referencePoint == display.BottomLeftReferencePoint then
                    _displayObject.contentBounds.xMin = value
                    _displayObject.contentBounds.xMax = value + _displayObject.width
                elseif _displayObject.referencePoint == display.TopRightReferencePoint
                    or _displayObject.referencePoint == display.CenterRightReferencePoint
                    or _displayObject.referencePoint == display.BottomRightReferencePoint then
                    _displayObject.contentBounds.xMin = value - _displayObject.width
                    _displayObject.contentBounds.xMax = value
                else
                    _displayObject.contentBounds.xMin = value - _displayObject.width * 0.5
                    _displayObject.contentBounds.xMax = value + _displayObject.width * 0.5
                end
            elseif key == "y" then
                if _displayObject.referencePoint == display.TopLeftReferencePoint
                    or _displayObject.referencePoint == display.TopCenterReferencePoint
                    or _displayObject.referencePoint == display.TopRightReferencePoint then
                    _displayObject.contentBounds.yMin = value
                    _displayObject.contentBounds.yMax = value + _displayObject.height
                elseif _displayObject.referencePoint == display.CenterLeftReferencePoint
                    or _displayObject.referencePoint == display.CenterReferencePoint
                    or _displayObject.referencePoint == display.CenterRightReferencePoint then
                    _displayObject.contentBounds.yMin = value - _displayObject.width * 0.5
                    _displayObject.contentBounds.yMax = value + _displayObject.width * 0.5
                else
                    _displayObject.contentBounds.xMin = value - _displayObject.width
                    _displayObject.contentBounds.xMax = value
                end
            elseif key == "width" then
                if _displayObject.referencePoint == display.TopLeftReferencePoint
                    or _displayObject.referencePoint == display.CenterLeftReferencePoint
                    or _displayObject.referencePoint == display.BottomLeftReferencePoint then
                    _displayObject.contentBounds.xMax = _displayObject.contentBounds.xMin + _displayObject.width
                elseif _displayObject.referencePoint == display.TopRightReferencePoint
                    or _displayObject.referencePoint == display.CenterRightReferencePoint
                    or _displayObject.referencePoint == display.BottomRightReferencePoint then
                    _displayObject.contentBounds.xMin = _displayObject.contentBounds.xMax - _displayObject.width
                else
                    _displayObject.contentBounds.xMin = _displayObject.contentBounds.x - _displayObject.width * 0.5
                    _displayObject.contentBounds.xMax = _displayObject.contentBounds.x + _displayObject.width * 0.5
                end
            elseif key == "height" then
                if _displayObject.referencePoint == display.TopLeftReferencePoint
                    or _displayObject.referencePoint == display.TopCenterReferencePoint
                    or _displayObject.referencePoint == display.TopRightReferencePoint then
                    _displayObject.contentBounds.yMax = _displayObject.contentBounds.yMin + _displayObject.height
                elseif _displayObject.referencePoint == display.CenterLeftReferencePoint
                    or _displayObject.referencePoint == display.CenterReferencePoint
                    or _displayObject.referencePoint == display.CenterRightReferencePoint then
                    _displayObject.contentBounds.yMin = _displayObject.contentBounds.y - _displayObject.width * 0.5
                    _displayObject.contentBounds.yMax = _displayObject.contentBounds.y + _displayObject.width * 0.5
                else
                    _displayObject.contentBounds.xMin = _displayObject.contentBounds.xMax - _displayObject.width
                end
            elseif key == "xOrigin" or key == "yOrigin" or key == "xReference" or key == "yReference" then
                assert(false, "origin and reference point changes supported only through setReferencePoint")
            end
            _displayObject[key] = value
        end
    }
    setmetatable(displayObject, metatable)

    return displayObject
end

local _currentStage = {
    focused = nil,
}
_currentStage.setFocus = function(self, focus)
    _currentStage.focused = focus
end

display = {
    newRect = function(x, y, width, height)
        local rect = newDisplayObject()
        rect.x = x
        rect.y = y
        rect.contentBounds = { xMin = x, xMax = x + width, yMin = y, yMax = y + width }
        return rect
    end,
    newGroup = function()
        local group = newDisplayObject()
        group.children = {}
        group.insert = function(self, what)
            what.parent = group
            table.insert(group.children, what)
        end
        group.remove = function(self, what)
            local rem = 0
            for i = 1, #group.children do
                if group.children[i] == what then
                    rem = i
                    break
                end
            end
            if rem > 0 then
                table.remove(group.children, rem)
            end
        end
        group.removeSelf = function()
            for i = #group.children, 1, -1 do
                group.children[i]:removeSelf()
                table.remove(group.children, i)
            end
            group = {}
        end
        group.contentWidth = function()
            if (#group.children == 0) then return 0 end
            if (#group.children == 1) then
                return group.children[1].contentBounds.xMax - group.children[1].contentBounds.xMin
            end
            local xMin, xMax
            xMin = #group.children[1].contentBounds.xMin
            xMax = #group.children[1].contentBounds.xMax
            for i = 2, #group.children do
                if xMin > group.children[i].contentBounds.xMin then xMin = group.children[i].contentBounds.xMin end
                if xMax > group.children[i].contentBounds.xMax then xMax = group.children[i].contentBounds.xMax end
            end
            return xMax - xMin
        end
        group.contentHeight = function()
            if (#group.children == 0) then return 0 end
            if (#group.children == 1) then return
                group.children[1].contentBounds.yMax - group.children[1].contentBounds.yMin
            end
            local yMin, yMax
            yMin = #group.children[1].contentBounds.yMin
            yMax = #group.children[1].contentBounds.yMax
            for i = 2, #group.children do
                if yMin > group.children[i].contentBounds.yMin then yMin = group.children[i].contentBounds.yMin end
                if yMax > group.children[i].contentBounds.yMax then yMax = group.children[i].contentBounds.yMax end
            end
            return yMax - yMin
        end
        return group
    end,
    newImage = function(parent, frame)
        local image = newDisplayObject()
        image.width = parent.width
        image.height = parent.height
        return image
    end,
    newImageRect = function(parent, frame)
        local image = newDisplayObject()
        image.width = parent.width
        image.height = parent.height
        return image
    end,
    newSprite = function(imageSheet, sequenceData)
        local sprite = newDisplayObject()
        sprite.imageSheet = imageSheet
        sprite.sequenceData = sequenceData
        sprite.frame = 1
        sprite.setFrame = function(frame)
            sprite.frame = frame
        end

        return sprite
    end,
    newText = function(text, x, y, font, size)
        local newText = newDisplayObject()
        newText.setTextColor = function(r, g, b)
            newText.textColor = { r = r, g = g, b = b }
        end


        newText.x = x
        newText.y = y
        newText.text = text
        newText.size = size
        return newText
    end,
    newEmbossedText = function(options)
        local newText = newDisplayObject()
        newText.setEmbossColor = function(text, color)
            local highlight = color.highlight
            local shadow = color.shadow
            newText.highlight = { r = highlight.r, g = highlight.g, b = highlight.b }
            newText.shadow = { r = shadow.r, g = shadow.g, b = shadow.b }
        end

        newText.x = options.x
        newText.y = options.y
        newText.text = options.text
        newText.size = options.size

        return newText
    end,
    currentStage = _currentStage,
    getCurrentStage = function() return display.currentStage end,
    TopLeftReferencePoint = 7,
    TopCenterReferencePoint = 8,
    TopRightReferencePoint = 9,
    CenterLeftReferencePoint = 4,
    CenterReferencePoint = 5,
    CenterRightReferencePoint = 4,
    BottomLeftReferencePoint = 1,
    BottomCenterReferencePoint = 2,
    BottomRightReferencePoint = 3,
    contentWidth = 640,
    contentHeight = 960,
    screenOriginX = 0,
    screenOriginY = 0,
    contentScaleY = 1,
    contentScaleX = 1
}

return display
