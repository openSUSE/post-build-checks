export SUSE_IGNORED_RPATHS=/etc/suse-ignored-rpaths.conf
export SUSE_ASNEEDED=1
export SUSE_ZNOW=1

# for reproducible builds
export QT_HASH_SEED=0
export PERL_HASH_SEED=42
export PYTHONHASHSEED=0
export FORCE_SOURCE_DATE=1 # for texlive to use SOURCE_DATE_EPOCH

if test ! -v SOURCE_DATE_EPOCH && test -f /.buildenv && test "Y" != "$(rpm --eval '%disable_obs_set_source_date_epoch')"; then
    BROKEN_SOURCE_DATE_EPOCH="$(
    . /.buildenv
    if test -f "$TOPDIR/SOURCES/_scmsync.obsinfo" ; then
        mtime="$(grep mtime "$TOPDIR/SOURCES/_scmsync.obsinfo" |cut -d ' ' -f 2)"
        if test 1 -gt "$mtime" ; then
            echo "WARNING mtime in \TOPDIR/SOURCES/_scmsync.obsinfo seems invalid as it is less than 1" >&2
        fi
    elif test -v BUILD_CHANGELOG_TIMESTAMP ; then
        mtime=$BUILD_CHANGELOG_TIMESTAMP
        if test 1 -gt "$mtime" ; then
            echo "WARNING BUILD_CHANGELOG_TIMESTAMP in /.buildenv seems invalid as it is less than 1" >&2
        fi
    else
        echo "WARNING could not set SOURCE_DATE_EPOCH, ensure mtime is in \$TOPDIR/SOURCES/_scmsync.obsinfo or BUILD_CHANGELOG_TIMESTAMP is set in /.buildenv" >&2
    fi
    echo "$mtime"
    )"
    if test -z "$BROKEN_SOURCE_DATE_EPOCH"; then
        unset BROKEN_SOURCE_DATE_EPOCH
    else
        export BROKEN_SOURCE_DATE_EPOCH
    fi
    SOURCE_DATE_EPOCH="$(
    . /.buildenv
    if test -v BUILD_RELEASE && test -v BROKEN_SOURCE_DATE_EPOCH; then
        counter="$(echo "$BUILD_RELEASE" |cut -d '.' -f 2)"
        if test 1 -gt "$counter" ; then
            echo "WARNING number after \".\" in BUILD_RELEASE in /.buildenv seems invalid as it is less than 1" >&2
        fi
        date=$(( BROKEN_SOURCE_DATE_EPOCH + counter ))
        echo "setting SOURCE_DATE_EPOCH to $date" >&2
    else
        echo "WARNING could not set SOURCE_DATE_EPOCH, ensure BUILD_RELEASE is set in /.buildenv" >&2
    fi
    echo "$date"
    )"
    if test -z "$SOURCE_DATE_EPOCH"; then
        unset SOURCE_DATE_EPOCH
    else
        export SOURCE_DATE_EPOCH
    fi
    if test "$SOURCE_DATE_EPOCH" -ge "$(date '+%s')" ; then
        echo "ERROR SOURCE_DATE_EPOCH is in the future, clamping mtime if used might fail in hard to notice way, returning error" >&2
        exit 1
    fi
fi
