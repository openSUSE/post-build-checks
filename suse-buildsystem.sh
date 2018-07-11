export SUSE_IGNORED_RPATHS=/etc/suse-ignored-rpaths.conf
export SUSE_ASNEEDED=1

# for reproducible builds
export QT_HASH_SEED=0
export PERL_HASH_SEED=42
export PYTHONHASHSEED=0
export FORCE_SOURCE_DATE=1 # for texlive to use SOURCE_DATE_EPOCH
