# force rebuild targets:
.PHONY: test

ifeq ($(verbose), true)
	export DEBUG := true
endif

ifeq ($(env), travis)
root=/home/travis/build/chrisdugne/cherry
else
root=.
endif

# http://leafo.net/guides/customizing-the-luarocks-tree.html
export LUA_PATH := ${root}/?.lua;$(LUA_PATH)
export LUA_PATH := ${root}/.rocks/share/lua/5.3/?.lua;$(LUA_PATH)
export LUA_PATH := ${root}/.rocks/share/lua/5.3/?/init.lua;$(LUA_PATH)
export LUA_CPATH := ${root}/.rocks/lib/lua/5.3/?.so$(LUA_CPATH)

.rocks:
	@luarocks install --tree .rocks busted
	@luarocks install --tree .rocks luacheck
	@luarocks install --tree .rocks luacov
	@luarocks install --tree .rocks fp
	@luarocks install --tree .rocks dkjson

test: .rocks
	@.rocks/bin/luacheck .
	@.rocks/bin/busted -v	--run=tests --config-file=test/.busted \
			-m '${root}/test/?.lua;${root}/src/libs/?.lua;${root}/src/?.lua'

clean:
	@rm -rf .rocks
	@echo removed .rocks
