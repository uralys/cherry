--------------------------------------------------------------------------------

local json     = require('dkjson')
--------------------------------------------------------------------------------

local http = {}

--------------------------------------------------------------------------------

function http.request(url, method, next, data, type, authToken)
    local VERBOSE = false
    local DEV_BEARER = nil
    local headers = {}

    if(VERBOSE) then print(method, url) end
    if(next == nil) then
        next = function() end
    end


    ----------------------------------------

    local _authToken = authToken
    if (DEV_BEARER) then
        _authToken = DEV_BEARER
        print('Warning : DEV bearer : ' .. DEV_BEARER)
    end

    ----------------------------------------

    if(App.API_GATEWAY_KEY) then
        headers['x-api-key'] = App.API_GATEWAY_KEY
    end

    if(_authToken) then
        headers['X-Auth-Token'] = _authToken
        headers['Authorization'] = 'Bearer ' .. _authToken
    end

    if(type == nil) then
        headers['Content-Type'] = 'Application/json'
    elseif(type == 'urlencoded') then
        headers['Content-Type'] = 'Application/x-www-form-urlencoded'
    end

    ----------------------------------------

    -- TODO use this + success/fail instead of next
    -- local listener = function(event)
    --     if ( event.isError ) then
    --         print( 'Network error!' )
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

function http.post(url, data, next, _type)
    if(type(data) ~= 'string') then
        data = json.encode(data)
    end

    http.request(url, 'POST', next, data, _type)
end

function http.get(url, next)
    http.request(url, 'GET', next)
end

function http.put(url, data, next)
    if(type(data) ~= 'string') then
        data = json.encode(data)
    end

    http.request(url, 'PUT', next, data)
end

function http.delete(url, next)
    http.request(url, 'DELETE', next)
end

--------------------------------------------------------

function http.url_decode(str)
    str = string.gsub (str, '+', ' ')
    str = string.gsub (str, '%%(%x%x)',
    function(h) return string.char(tonumber(h,16)) end)
    str = string.gsub (str, '\r\n', '\n')
    return str
end

function http.urlEncode(str)
    if (str) then
        str = string.gsub (str, '\n', '\r\n')
        str = string.gsub (str, '([^%w ])',
        function (c) return string.format ('%%%02X', string.byte(c)) end)
        str = string.gsub (str, ' ', '+')
    end
    return str
end

--------------------------------------------------------

function http.networkConnection()
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

--------------------------------------------------------------------------------

return http

