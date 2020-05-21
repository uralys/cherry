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
	. ${rocksDir}/bin/activate

rocks:
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} dkjson
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} luacov
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} luacheck
	@${rocksDir}/bin/luarocks install --tree ${rocksDir} busted

luacheck:
	@${rocksDir}/bin/luacheck .

busted:
	@${rocksDir}/bin/busted -v --run=tests --config-file=test/.busted \
			-m '${root}/test/?.lua;'

test: luacheck busted

clean:
	@rm -rf ${rocksDir}
	@echo removed ${rocksDir}
