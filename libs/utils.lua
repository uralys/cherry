--------------------------------------------------------------------------------

local Vector2D = require 'vector2D'
local json     = require('dkjson')

local utils = {}

--------------------------------------------------------------------------------

function utils.toColor(hexCode)
    return tonumber('0x'..hexCode:sub(1,2))/255,
           tonumber('0x'..hexCode:sub(3,4))/255,
           tonumber('0x'..hexCode:sub(5,6))/255;
end

utils.colorize = utils.toColor

--------------------------------------------------------------------------------

function utils.isInt(n)
  return n==math.floor(n)
end

--------------------------------------------------------------------------------

function utils.toPercentage(nb, max)
    local percent = math.min(100, math.round ( nb / max  * 100))

    return  {
        value = percent,
        text = nb .. '/' .. max
    }
end

--------------------------------------------------------------------------------

function utils.text(options)
    local _text = display.newEmbossedText({
        parent   = options.parent,
        text     = options.value,
        x        = options.x,
        y        = options.y,
        width    = options.width,
        height   = options.height,
        font     = options.font,
        fontSize = options.fontSize
    })

    local color = {
        highlight = { r=1, g=1, b=1 },
        shadow = { r=0.3, g=0.3, b=0.3 }
    }

    _text:setEmbossColor( color )
    return _text
end

function utils.simpleText(options)
    local _text = display.newText({
        parent   = options.parent,
        text     = options.value,
        x        = options.x,
        y        = options.y,
        width    = options.width,
        height   = options.height,
        font     = options.font,
        fontSize = options.fontSize
    })

    _text:setFillColor( options.color )
    return _text
end

--------------------------------------------------------------------------------

function utils.getMinSec(seconds)
    local min = math.floor(seconds/60)
    local sec = seconds - min * 60

    if(sec < 10) then
        sec = "0" .. sec
    end

    return min, sec
end

function utils.getMinSecMillis(millis)
    local min = math.floor(millis/60000)
    local sec = math.floor((millis - min * 60 * 1000)/1000)
    local ms = math.floor(millis - min * 60 * 1000 - sec * 1000)

    if(sec < 10) then
        sec = "0" .. sec
    end

    if(ms < 10) then
        ms = "00" .. ms
    elseif(ms < 100) then
        ms = "0" .. ms
    end

    return min, sec, ms
end

function utils.getUrlParams(url)

    local index = string.find(url,"?")
    local paramsString = url:sub(index+1, string.len(url) )

    local params = {}

    utils.fillNextParam(params, paramsString);

    return params;

end

function utils.fillNextParam(params, paramsString)

    local indexEqual = string.find(paramsString,"=")
    local indexAnd = string.find(paramsString,"&")

    local indexEndValue
    if(indexAnd == nil) then
        indexEndValue = string.len(paramsString)
    else
        indexEndValue = indexAnd - 1
    end

    if ( indexEqual ~= nil ) then
        local varName = paramsString:sub(0, indexEqual-1)
        local value = paramsString:sub(indexEqual+1, indexEndValue)
        params[varName] = utils.url_decode(value)

        if (indexAnd ~= nil) then
            paramsString = paramsString:sub(indexAnd+1, string.len(paramsString) )
            utils.fillNextParam(params, paramsString)
        end

    end

end

--------------------------------------------------------------------------------

function utils.emptyGroup( group )
    if(group ~= nil and group.numChildren ~= nil and group.numChildren > 0) then
        for i=group.numChildren,1,-1 do
            local child = group[i]
            transition.cancel(child)
            child:removeSelf()
            group[i] = nil
        end
    end
end

function utils.destroyFromDisplay(object, easeHideEffect)
    local doDestroy = function()
        if(object) then
            utils.emptyGroup(object)
            display.remove(object)
            object = nil
        end
    end

    if(easeHideEffect) then
        utils.easeHide(object, doDestroy, 125)
    else
        doDestroy()
    end
end

--------------------------------------------------------------------------------

function string.startsWith(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

function string.endsWith(String,End)
    return End=='' or string.sub(String,-string.len(End))==End
end

--------------------------------------------------------------------------------

function utils.joinTables(t1, t2)

    local result = {}
    if(t1 == nil) then t1 = {} end
    if(t2 == nil) then t2 = {} end

    for k,v in pairs(t1) do
        result[k] = v
    end

    for k,v in pairs(t2) do
        result[k] = v
    end

    return result
end

--------------------------------------------------------------------------------

function utils.removeFromTable(t, object)
    local index = 1
    for k,_ in pairs(t) do
        if(t[k] == object) then
            break
        end

        index = index + 1
    end

    table.remove(t, index)
end

function utils.emptyTable(t)
    if(not t) then return end
    local i, _ = next(t, nil)
    while i do
        t[i] = nil
        i, _ = next(t, i)
    end
end

function utils.contains(t, object)
    if(not t) then return end
    for _,v in pairs(t) do
        if(v == object) then
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------

function utils.imageName( url )
    local index = string.find(url,"/")

    if(index == nil) then
        if(not string.endsWith(url, ".png")) then
            url = url .. ".png"
        end
        return url;
    else
        local subURL = url:sub(index+1, string.len(url))
        return utils.imageName(subURL)
    end
end

--------------------------------------------------------------------------------

-- use :
-- utils.tprint(object)
-- utils.tprint(object, nil, options)
function utils.tprint (tbl, indent, options)

    if not tbl then print("Table nil") return end
    if not options then options = {} end
    if options.showUnderscores then print('--> showing _* properties') end

    if type(tbl) ~= "table" then
        print(tostring(tbl))
    else
        if not indent then indent = 1 end
        for k, v in pairs(tbl) do
            local show = not string.startsWith(k, '_')
                         or  options.showUnderscores == true
            if(show) then
                local formatting = string.rep("  ", indent) .. k .. ": "
                if type(v) == "table" then
                    print(formatting)
                    if(indent < 6) then
                        utils.tprint(v, indent+1, options)
                    end
                else
                    print(formatting .. tostring(v))
                end
            end
        end
    end
end

--------------------------------------------------------------------------------

function utils.request(url, method, next, data, type, authToken)
    local VERBOSE = false
    local DEV_BEARER = '234567'

    if(VERBOSE) then print(method, url) end
    if(next == nil) then
        next = function() end
    end

    ----------------------------------------

    authToken = authToken or ''

    if (DEV_BEARER) then
        authToken = DEV_BEARER
        print('Warning : DEV bearer : ' .. DEV_BEARER)
    end

    ----------------------------------------

    local headers = {}

    if(type == nil) then
        headers["Content-Type"] = "Application/json"
        headers["X-Auth-Token"] = authToken
        headers["Authorization"] = 'Bearer ' .. authToken
    elseif(type == "urlencoded") then
        headers["Content-Type"] = "Application/x-www-form-urlencoded"
    end


    ----------------------------------------

    -- TODO use this + success/fail instead of next
    -- local listener = function(event)
    --     if ( event.isError ) then
    --         print( "Network error!" )
    --     else
    --         next()
    --     end
    -- end

    ----------------------------------------

    network.request( url, method, next, {
        headers = headers,
        body    = data
    })

end

--------------------------------------------------------

function utils.post(url, data, next, _type)
    if(type(data) ~= 'string') then
        data = json.encode(data)
    end

    utils.request(url, "POST", next, data, _type)
end

function utils.get(url, next)
    utils.request(url, "GET", next)
end

function utils.put(url, data, next)
    if(type(data) ~= 'string') then
        data = json.encode(data)
    end

    utils.request(url, "PUT", next, data)
end

function utils.delete(url, next)
    utils.request(url, "DELETE", next)
end


--------------------------------------------------------

function utils.isEmail(str)
    return str:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")
end

--------------------------------------------------------

function utils.url_decode(str)
    str = string.gsub (str, "+", " ")
    str = string.gsub (str, "%%(%x%x)",
    function(h) return string.char(tonumber(h,16)) end)
    str = string.gsub (str, "\r\n", "\n")
    return str
end

function utils.urlEncode(str)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str
end

--------------------------------------------------------

function utils.parseDate(str)
    local _,_,y,m,d=string.find(str, "(%d+)-(%d+)-(%d+)")
    return tonumber(y),tonumber(m),tonumber(d)
end

function utils.parseDateTime(str)
    local Y,M,D = utils.parseDate(str)
    return os.time({year=Y, month=M, day=D})
end

--------------------------------------------------------

function utils.assetExists(filename)
    local path = system.pathForFile( filename, system.ResourceDirectory)
    return path
end

--------------------------------------------------------

function utils.saveTable(t, filename, directory)

    if(not directory) then
        directory = system.DocumentsDirectory
    end

    local path = system.pathForFile( filename, directory)
    local file = io.open(path, 'w')
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end

local function loadTable(path)
    local file = io.open( path, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        local myTable = json.decode(contents);
        io.close( file )
        return myTable
    end
    return nil
end

--------------------------------------------------------

function utils.getPointsBetween(from, to, nbPoints)

    if(from.x > to.x) then
        local swap = from
        from = to
        to = swap
    end

    local x1,y1 = from.x,from.y
    local x2,y2 = to.x,to.y

    local step = math.abs(x2-x1)/nbPoints
    local points = {}

    local a = (y2-y1)/(x2-x1)

    for i=0,nbPoints do
        local x = x1 + i*step
        local y = y1 + a*(x - x1)
        table.insert(points, Vector2D:new(x, y))
    end

    return points
end

--------------------------------------------------------

function utils.networkConnection()
    local status

    local socket = require('socket')
    local test = socket.tcp()
    test:settimeout(2000)

    -- Note that the test does not work if we put http:// in front
    local testResult = test:connect('www.google.com', 80)

    if not(testResult == nil) then
        status = true
    else
        status = false
    end

    test:close()
    return status
end

--------------------------------------------------------

function utils.displayCounter(numToReach, writer, anchorX, anchorY, x, next, nextMillis)
    writer.currentDisplay = writer.currentDisplay or 0
    timer.performWithDelay(25, function()

        local ratio = (4 * numToReach)/(numToReach - writer.currentDisplay)
        local toAdd = math.floor(numToReach/ratio)
        if(toAdd == 0) then toAdd = 1 end

        writer.currentDisplay = math.round(writer.currentDisplay + toAdd)

        if(writer.currentDisplay >= numToReach) then
            writer.currentDisplay = math.round(numToReach)
            next()
        else
            nextMillis = 100/(numToReach - writer.currentDisplay)
            utils.displayCounter(numToReach, writer, anchorX, anchorY, x, next, nextMillis)
        end

        writer.text    = writer.currentDisplay
        writer.x       = x
        writer.anchorX = anchorX
        writer.anchorY = anchorY
    end)
end

--------------------------------------------------------

function utils.rotateBackAndForth(object, angle, time)

    local initialRotation = object.rotation

    local back = function()
        transition.to(object, {
            rotation   = initialRotation,
            onComplete = utils.rotateBackAndForth(object, -angle, time),
            time       = time
        })
    end

    transition.to(object, {
        rotation   = angle,
        onComplete = back,
        time       = time
    })
end

--------------------------------------------------------

function utils.easeDisplay(object, scale)
    local scaleTo = scale or 1
    object.xScale = 0.2
    object.yScale = 0.2

    return transition.to( object, {
        xScale = scaleTo,
        yScale = scaleTo,
        time = 350,
        transition = easing.outCubic
    })
end

function utils.bounce(object, scale)
    local scaleTo = scale or 1

    object.xScale = 0.01
    object.yScale = 0.01
    timer.performWithDelay(math.random(120, 330), function()
        transition.to( object, {
            xScale = scaleTo,
            yScale = scaleTo,
            time = 750,
            transition = easing.outBounce
        })
    end)
end

function utils.grow(object, fromScale, time, onComplete)
    object.xScale = fromScale or 0.6
    object.yScale = fromScale or 0.6

    transition.to( object, {
        xScale = 1,
        yScale = 1,
        time = time or 350,
        onComplete = onComplete
    })
end

function utils.easeHide(object, next, time)
    transition.to( object, {
        xScale = 0.01,
        yScale = 0.01,
        time = time or 450,
        transition = easing.inCubic,
        onComplete = function()
            if(next) then
                next()
            end
        end
    })
end

function utils.fadeIn(object)
    object.alpha = 0

    transition.to( object, {
        alpha = 1,
        time = 750
    })
end

--------------------------------------------------------

function utils.loadUserData(file)
    return loadTable(system.pathForFile( file , system.DocumentsDirectory))
end

function utils.loadFile(path)
    local resource = system.pathForFile( path , system.ResourceDirectory)
    if(not resource) then
        return false
    end
    return loadTable(resource)
end

--------------------------------------------------------
--- http://developer.coronalabs.com/code/maths-library

-- returns the distance between points a and b
function utils.distanceBetween( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return (width*width + height*height)^0.5 -- math.sqrt(width*width + height*height)
    -- nothing wrong with math.sqrt, but I believe the ^.5 is faster
end

--------------------------------------------------------------------------------

function utils.openWeb(url, listener, customOnClose)

    ------------------

    local webContainer = {}
    local HEADER_HEIGHT = display.contentHeight / 6

    ------------------

    local webView = native.newWebView(
        display.contentCenterX,
        display.contentCenterY,
        display.contentWidth,
        display.contentHeight - HEADER_HEIGHT
    )

    webView:request( url )

    if(listener) then
        webView:addEventListener( "urlRequest", listener )
    end

    ------------------

    local onClose = function ()

        if(listener) then
            webView:removeEventListener( "urlRequest", listener )
        end

        webView:removeSelf()
        webView = nil

        display.remove(webContainer.headerRect)
        display.remove(webContainer.logo)
        display.remove(webContainer.close)
        webContainer = nil

        if(customOnClose) then
            customOnClose()
        end
    end

    ------------------

    return onClose
end

--------------------------------------------------------------------------------

function utils.curveText(options)
    local curvedText = display.newGroup()
    local circleSize = options.curveSize or 250
    local step       = options.fontSize*(0.33/#options.text)

    for i = 1, #options.text do
        local angleDegrees = (i - (#options.text+1.5)/2)*step - 90
        local angleRadians = math.rad(angleDegrees)

        local sprite = display.newEmbossedText(
            curvedText,
            options.text:sub(i, i),
            0, 0,
            options.font,
            options.fontSize or 65
        )
        sprite.x = options.x + math.cos(angleRadians)*circleSize
        sprite.y = options.y + math.sin(angleRadians)*circleSize
        sprite.rotation = 90 + angleDegrees -- or maybe minus this or plus 90...

        local color =
        {
            highlight = { r=0.2, g=0.2, b=0.2 },
            shadow = { r=0.2, g=0.2, b=0.2 }
        }
        sprite:setEmbossColor( color )

    end

    options.parent:insert(curvedText)

    return curvedText
end

--------------------------------------------------------------------------------

return utils
