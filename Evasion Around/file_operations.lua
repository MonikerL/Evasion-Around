local json = require( "json" )
local defaultLocation = system.DocumentsDirectory

function saveData( t, filename, location )
 
    local loc = location
    if not location then
        loc = defaultLocation
    end
 
    -- Path for the file to write
    local path = system.pathForFile( filename, loc )
 
    -- Open the file handle
    local file, errorString = io.open( path, "w" )
 
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Write encoded JSON data to file
        file:write( json.encode( t ) )
        -- Close the file handle
        io.close( file )
        return true
    end
end

function loadData( filename, location )
 
    local loc = location
    if not location then
        loc = defaultLocation
    end
 
    -- Path for the file to read
    local path = system.pathForFile( filename, loc )
 
    -- Open the file handle
    local file, errorString = io.open( path, "r" )
 
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Read data from file
        local contents = file:read( "*a" )
        -- Decode JSON data into Lua table
        local t = json.decode( contents )
        -- Close the file handle
        io.close( file )
        -- Return table
        return t
    end
end

function doesFileExist( fname, path )
 
    local results = false
 
    -- Path for the file
    local filePath = system.pathForFile( fname, path )
 
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )
 
        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- File exists!
            print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end
 
    return results
end