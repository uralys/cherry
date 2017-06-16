local cherryPath = system.pathForFile( 'Cherry/', system.ResourceDirectory )
local appPath = system.pathForFile( './', system.ResourceDirectory )

package.path = package.path .. cherryPath ..'?.lua;'
package.path = package.path .. cherryPath .. 'libs/?.lua;'
package.path = package.path .. appPath .. 'src/?.lua;'
require 'cherry'
