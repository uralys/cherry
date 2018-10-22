rocksDir=.rocks
ifeq ($(env), travis)
	root=/home/travis/build/chrisdugne/cherry
else
	root=.
endif

ifeq ($(verbose), true)
	export DEBUG := true
endif

rocks:
	@luarocks install --tree ${rocksDir} dkjson
	@luarocks install --tree ${rocksDir} luacov
	@luarocks install --tree ${rocksDir} luacheck
	@luarocks install --tree ${rocksDir} busted

luacheck:
	@${rocksDir}/bin/luacheck .

busted:
	@${rocksDir}/bin/busted -v --run=tests --config-file=test/.busted \
			-m '${root}/test/?.lua;${root}/src/libs/?.lua;${root}/src/?.lua'

test: rocks luacheck busted

clean:
	@rm -rf ${rocksDir}
	@echo removed ${rocksDir}
