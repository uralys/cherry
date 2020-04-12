SHELL := /bin/bash
rocksDir=.rocks
ifeq ($(env), travis)
	root=/home/travis/build/chrisdugne/cherry
else
	root=.
endif

ifeq ($(verbose), true)
	export DEBUG := true
endif

install: clean hererocks rocks

hererocks:
	hererocks ${rocksDir} -r^ --lua=5.1
	source ${rocksDir}/bin/activate

rocks:
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} dkjson
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} luacov

	# deps to luacheck...not auto installed ?
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} argparse
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} luafilesystem
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} luacheck


	# deps to busted...not auto installed ?
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} lua_cliargs
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} luasystem
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} say
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} luassert
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} lua-term
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} penlight
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} mediator_lua
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} busted

luacheck:
	@${rocksDir}/bin/luacheck .

busted:
	@${rocksDir}/bin/busted -v --run=tests --config-file=test/.busted \
			-m '${root}/test/?.lua;${root}/src/libs/?.lua;${root}/src/?.lua'

test: luacheck busted

clean:
	@rm -rf ${rocksDir}
	@echo removed ${rocksDir}
