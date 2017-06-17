local cherryPath = system.pathForFile( 'Cherry/', system.ResourceDirectory )
local cherrySrcPath = system.pathForFile( 'Cherry/src/', system.ResourceDirectory )
local appPath = system.pathForFile( './', system.ResourceDirectory )

package.path = package.path .. cherryPath ..'?.lua;'
package.path = package.path .. cherrySrcPath ..'?.lua;'
package.path = package.path .. cherrySrcPath .. 'libs/?.lua;'
package.path = package.path .. appPath .. 'src/?.lua;'

require 'cherry'
