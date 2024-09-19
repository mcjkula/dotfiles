local home = os.getenv("HOME")
package.path = package.path .. ";" .. home .. "/.luarocks/share/lua/5.4/?.lua"
package.cpath = package.cpath .. ";" .. home .. "/.luarocks/lib/lua/5.4/?.so"

local dotenv = require("lua-dotenv")
dotenv.load_dotenv()

_G.dotenv = dotenv
