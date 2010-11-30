PRJ=Base:System
PKG=post-build-checks

all:

package:
	@if test -d $(PKG); then cd $(PKG) && osc up && cd -; else osc co -c $(PRJ) $(PKG); fi
	@./mkchanges | tee $(PKG)/.changes
	@test ! -s $(PKG)/.changes || git push
	@test -z "`git rev-list remotes/origin/master..master`" || { echo "unpushed changes"; exit 1; }
	@f=(*bz2); test -z "$f" || /bin/rm -vi *.bz2
	@./mktar
	@mv *bz2 $(PKG)

.PHONY: all package
