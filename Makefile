# force rebuild targets:
.PHONY: test

ifeq ($(verbose), true)
export DEBUG := true
endif

ifeq ($(env), travis)
root=/home/travis/build/chrisdugne/cherry
else
root=.
LUA_VERSION=5.3
endif

# http://leafo.net/guides/customizing-the-luarocks-tree.html
export LUA_PATH := ${root}/?.lua;$(LUA_PATH)
export LUA_PATH := ${root}/.rocks/share/lua/${LUA_VERSION}/?.lua;$(LUA_PATH)
export LUA_PATH := ${root}/.rocks/share/lua/${LUA_VERSION}/?/init.lua;$(LUA_PATH)
export LUA_CPATH := ${root}/.rocks/lib/lua/${LUA_VERSION}/?.so$(LUA_CPATH)

.rocks:
	@luarocks install --tree .rocks busted
	@luarocks install --tree .rocks luacheck
	@luarocks install --tree .rocks luacov
	@luarocks install --tree .rocks dkjson

luacheck:
	@.rocks/bin/luacheck .

busted:
	@.rocks/bin/busted -v --run=tests --config-file=test/.busted \
			-m '${root}/test/?.lua;${root}/src/libs/?.lua;${root}/src/?.lua'

test: .rocks luacheck busted

clean:
	@rm -rf .rocks
	@echo removed .rocks
