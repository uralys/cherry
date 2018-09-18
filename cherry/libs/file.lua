--------------------------------------------------------------------------------

local json = require('dkjson')
local file = {}

-- assetExists --> exists
-- saveTable -->  save
-- loadFile --> load

--------------------------------------------------------------------------------

local function load(path)
    local _file = io.open( path, "r" )
    if _file then
        -- read all contents of file into a string
        local contents = _file:read( "*a" )
        local myTable = json.decode(contents);
        io.close( _file )
        return myTable
    end
    return nil
end

--------------------------------------------------------------------------------

function file.exists(filename)
    local path = system.pathForFile( filename, system.ResourceDirectory)
    return path ~= nil
end

--------------------------------------------------------

function file.save(t, filename, directory)

    if(not directory) then
        directory = system.DocumentsDirectory
    end

    local path = system.pathForFile( filename, directory)
    local _file = io.open(path, 'w')
    if _file then
        local contents = json.encode(t, {indent = true})
        _file:write( contents )
        io.close( _file )
        return true
    else
        return false
    end
end

--------------------------------------------------------

function file.loadUserData(_file)
    return load(system.pathForFile( _file , system.DocumentsDirectory))
end

function file.load(path)
    local resource = system.pathForFile( path , system.ResourceDirectory)
    if(not resource) then
        return false
    end
    return load(resource)
end

--------------------------------------------------------------------------------

return file
