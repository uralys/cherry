--------------------------------------------------------------------------------
--- wow wow wow... sorry for the crap stacked here from diligis, adillions,
-- the lightning planet, kodo, behind the wind...and phantoms...
--
-- this will be the first required cleanup for Cherry I guess
--------------------------------------------------------------------------------

module(..., package.seeall)

--------------------------------------------------------------------------------

function oppositeDirection(direction)
    local oppositeDirection = (direction + 2)%4
    if(oppositeDirection == 0 ) then oppositeDirection = 4 end
    return oppositeDirection
end

--------------------------------------------------------------------------------

function onTouch(object, action)
    object:addEventListener ("touch", function(event)
        if(event.phase == "began") then
            object.alpha = 0.8
            display.getCurrentStage():setFocus( object )
        elseif event.phase == "ended" or event.phase == "cancelled" then
            object.alpha = 1
            display.getCurrentStage():setFocus( nil )
            action()
        end
        return true
    end)
end

--------------------------------------------------------------------------------

function onTap(object, action)
    object:addEventListener ("touch", function(event)
        if(event.phase == "began") then
            display.getCurrentStage():setFocus( object )
            return action()
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus( nil )
        end
    end)
end

--------------------------------------------------------------------------------

function isInt(n)
  return n==math.floor(n)
end

--------------------------------------------------------------------------------

function text(options)
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

--------------------------------------------------------------------------------

function getMinSec(seconds)
    local min = math.floor(seconds/60)
    local sec = seconds - min * 60

    if(sec < 10) then
        sec = "0" .. sec
    end

    return min, sec
end

function getMinSecMillis(millis)
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

function getUrlParams(url)

    local index = string.find(url,"?")
    local paramsString = url:sub(index+1, string.len(url) )

    local params = {}

    fillNextParam(params, paramsString);

    return params;

end

function fillNextParam(params, paramsString)

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
        params[varName] = url_decode(value)

        if (indexAnd ~= nil) then
            paramsString = paramsString:sub(indexAnd+1, string.len(paramsString) )
            fillNextParam(params, paramsString)
        end

    end

end

--------------------------------------------------------------------------------

function split(value, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    value:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

--------------------------------------------------------------------------------

function emptyGroup( group )
    if(group ~= nil and group.numChildren ~= nil and group.numChildren > 0) then
        for i=group.numChildren,1,-1 do
            local child = group[i]
            transition.cancel(child)
            child:removeSelf()
            child = nil
        end
    end
end

function destroyFromDisplay(object, easeHideEffect)
    local doDestroy = function()
        if(object) then
            emptyGroup(object)
            display.remove(object)
            object = nil
        end
    end

    if(easeHideEffect) then
        easeHide(object, doDestroy)
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

function joinTables(t1, t2)

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

function removeFromTable(t, object)
    local index = 1
    for k,v in pairs(t) do
        if(t[k] == object) then
            break
        end

        index = index + 1
    end

    table.remove(t, index)
end

function emptyTable(t)
    if(not t) then return end
    local i, v = next(t, nil)
    while i do
        t[i] = nil
        i, v = next(t, i)
    end
end

--------------------------------------------------------------------------------

function imageName( url )
    local index = string.find(url,"/")

    if(index == nil) then
        if(not string.endsWith(url, ".png")) then
            url = url .. ".png"
        end
        return url;
    else
        local subURL = url:sub(index+1, string.len(url))
        return imageName(subURL)
    end
end

--------------------------------------------------------------------------------

-- use :
-- utils.tprint(object)
-- utils.tprint(object, nil, options)
function tprint (tbl, indent, options)

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
                formatting = string.rep("  ", indent) .. k .. ": "
                if type(v) == "table" then
                    print(formatting)
                    if(indent < 6) then
                        tprint(v, indent+1, options)
                    end
                else
                    print(formatting .. tostring(v))
                end
            end
        end
    end
end

--------------------------------------------------------------------------------

function request(url, method, next, data, type)
    if(VERBOSE) then print(method, url) end
    if(next == nil) then
        next = function() end
    end

    ----------------------------------------

    local authToken = ''

    if (GLOBALS.savedData and GLOBALS.savedData.authToken) then
        authToken = GLOBALS.savedData.authToken
    end

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

function post(url, data, next, _type)
    if(type(data) ~= 'string') then
        data = json.encode(data)
    end

    utils.request(url, "POST", next, data, _type)
end

function get(url, next)
    utils.request(url, "GET", next)
end

function put(url, data, next)
    if(type(data) ~= 'string') then
        data = json.encode(data)
    end

    utils.request(url, "PUT", next, data)
end

function delete(url, next)
    utils.request(url, "DELETE", next)
end


--------------------------------------------------------

function isEmail(str)
    return str:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")
end

--------------------------------------------------------

function url_decode(str)
    str = string.gsub (str, "+", " ")
    str = string.gsub (str, "%%(%x%x)",
    function(h) return string.char(tonumber(h,16)) end)
    str = string.gsub (str, "\r\n", "\n")
    return str
end

function urlEncode(str)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str
end

--------------------------------------------------------

function parseDate(str)
    _,_,y,m,d=string.find(str, "(%d+)-(%d+)-(%d+)")
    return tonumber(y),tonumber(m),tonumber(d)
end

function parseDateTime(str)
    local Y,M,D = parseDate(str)
    return os.time({year=Y, month=M, day=D})
end

--------------------------------------------------------

function saveTable(t, filename, directory)

    if(not directory) then
        directory = system.DocumentsDirectory
    end

    local path = system.pathForFile( filename, directory)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end

function loadTable(path)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        myTable = json.decode(contents);
        io.close( file )
        return myTable
    end
    return nil
end

--------------------------------------------------------

function getPointsBetween(from, to, nbPoints)

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
        table.insert(points, vector2D:new(x, y))
    end

    return points
end

--------------------------------------------------------

function networkConnection()
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
    test = nil
    return status
end

--------------------------------------------------------

function displayCounter(numToReach, writer, anchorX, anchorY, x, next, nextMillis)
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
            displayCounter(numToReach, writer, anchorX, anchorY, x, next, nextMillis)
        end

        writer.text    = writer.currentDisplay
        writer.x       = x
        writer.anchorX = anchorX
        writer.anchorY = anchorY
    end)
end

----------------------------------------------------------------
--- before opening the App, call FB API to get the likes nb

function fetchGameData(openApp)
    GLOBALS.gameData = {
        facebookLikes = 0
    }

    local asyncResult = function(result)
        local data = json.decode(result.response)
        GLOBALS.gameData = data
    end

    if(networkConnection()) then
        local dataURL = 'http://www.uralys.com/games/data/phantoms.json?' .. os.time()
        utils.get(dataURL, asyncResult)
    end

    openApp()
end

--------------------------------------------------------

function rotateBackAndForth(object, angle, time)

    local initialRotation = object.rotation

    local back = function()
        transition.to(object, {
            rotation   = initialRotation,
            onComplete = rotateBackAndForth(object, -angle, time),
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

function easeDisplay(object, scale)
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

function bounce(object, scale)
    local scaleTo = scale or 1

    object.xScale = 0.01
    object.yScale = 0.01
    timer.performWithDelay(utils.random(120, 330), function()
        transition.to( object, {
            xScale = scaleTo,
            yScale = scaleTo,
            time = 750,
            transition = easing.outBounce
        })
    end)
end

function easeHide(object, next)
    transition.to( object, {
        xScale = 0.01,
        yScale = 0.01,
        time = 450,
        transition = easing.inCubic,
        onComplete = function()
            if(next) then
                next()
            end
        end
    })
end

function fadeIn(object)

    object.alpha = 0

    transition.to( object, {
        alpha = 1,
        time = 750
    })
end

--------------------------------------------------------

function loadUserData(file)
    return loadTable(system.pathForFile( file , system.DocumentsDirectory))
end

function loadFile(path)
    local resource = system.pathForFile( path , system.ResourceDirectory)
    if(not resource) then
        return false
    end
    return loadTable(resource)
end

--------------------------------------------------------
--- http://developer.coronalabs.com/code/maths-library

-- returns the distance between points a and b
function distanceBetween( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return (width*width + height*height)^0.5 -- math.sqrt(width*width + height*height)
    -- nothing wrong with math.sqrt, but I believe the ^.5 is faster
end

--------------------------------------------------------------------------------

function openWeb(url, listener, customOnClose)

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

function curveText(options)
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
end

--------------------------------------------------------------------------------

--[[
   Author: Julio Manuel Fernandez-Diaz
   Date:   January 12, 2007
   (For Lua 5.1)

   Modified slightly by RiciLake to avoid the unnecessary table traversal in tablecount()

   Formats tables with cycles recursively to any depth.
   The output is returned as a string.
   References to other tables are shown as values.
   Self references are indicated.

   The string returned is "Lua code", which can be procesed
   (in the case in which indent is composed by spaces or "--").
   Userdata and function keys and values are shown as strings,
   which logically are exactly not equivalent to the original code.

   This routine can serve for pretty formating tables with
   proper indentations, apart from printing them:

      print(table.show(t, "t"))   -- a typical use

   Heavily based on "Saving tables with cycles", PIL2, p. 113.

   Arguments:
      t is the table.
      name is the name of the table (optional)
      indent is a first indentation (optional).
--]]
function table.show(t, name, indent)
   local cart     -- a container
   local autoref  -- for self references

   --[[ counts the number of elements in a table
   local function tablecount(t)
      local n = 0
      for _, _ in pairs(t) do n = n+1 end
      return n
   end
   ]]
   -- (RiciLake) returns true if the table is empty
   local function isemptytable(t) return next(t) == nil end

   local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
         local info = debug.getinfo(o, "S")
         -- info.name is nil because o is not a calling level
         if info.what == "C" then
            return string.format("%q", so .. ", C function")
         else
            -- the information is defined through lines
            return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
         end
      elseif type(o) == "number" or type(o) == "boolean" then
         return so
      else
         return string.format("%q", so)
      end
   end

   local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name

      cart = cart .. indent .. field

      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ",\n"
      else
         if saved[value] then
            cart = cart .. " = {}; -- " .. saved[value]
                        .. " (self reference)\n"
            autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
         else
            saved[value] = name
            --if tablecount(value) == 0 then
            if isemptytable(value) then
               cart = cart .. " = {};\n"
            else
               cart = cart .. " = {\n"
               for k, v in pairs(value) do
                  -- k = basicSerialize(k)
                  local fname = string.format("%s[%s]", name, k)
                  -- field = string.format("[%s]", k)
                  field = k
                  -- three spaces between levels
                  addtocart(v, fname, indent .. "   ", saved, field)
               end
               cart = cart .. indent .. "},\n"
            end
         end
      end
   end

   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   print(cart .. autoref)
end
