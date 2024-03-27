export SUSE_IGNORED_RPATHS=/etc/suse-ignored-rpaths.conf
export SUSE_ASNEEDED=1
export SUSE_ZNOW=1

# for reproducible builds
export QT_HASH_SEED=0
export PERL_HASH_SEED=42
export PYTHONHASHSEED=0
export FORCE_SOURCE_DATE=1 # for texlive to use SOURCE_DATE_EPOCH

if test ! -v SOURCE_DATE_EPOCH && test -f /.buildenv && test "Y" != "$(rpm --eval '%disable_obs_set_source_date_epoch')"; then
    SOURCE_DATE_EPOCH="$(
    . /.buildenv
    if test -f "$TOPDIR/SOURCES/_scmsync.obsinfo" ; then
        mtime="$(grep mtime "$TOPDIR/SOURCES/_scmsync.obsinfo" |cut -d ' ' -f 2)"
        if test -z "$mtime" || test 1 -gt "$mtime" ; then
            echo "WARNING mtime in \TOPDIR/SOURCES/_scmsync.obsinfo seems invalid as it is less than 1" >&2
        fi
    elif test -v BUILD_CHANGELOG_TIMESTAMP ; then
        mtime=$BUILD_CHANGELOG_TIMESTAMP
        if test -z "$mtime" || test 1 -gt "$mtime" ; then
            echo "WARNING BUILD_CHANGELOG_TIMESTAMP in /.buildenv seems invalid as it is less than 1" >&2
        fi
    else
        echo "WARNING could not set SOURCE_DATE_EPOCH, ensure mtime is in \$TOPDIR/SOURCES/_scmsync.obsinfo or BUILD_CHANGELOG_TIMESTAMP is set in /.buildenv" >&2
    fi
    echo "$mtime"
    )"
    if test -z "$SOURCE_DATE_EPOCH"; then
        unset SOURCE_DATE_EPOCH
    fi
    SOURCE_DATE_EPOCH_MTIME="$(
    . /.buildenv
    if test -v BUILD_RELEASE && test -v SOURCE_DATE_EPOCH; then
        counter="$(echo "$BUILD_RELEASE" |cut -d '.' -f 2)"
        if test -z "$counter" || test 1 -gt "$counter" ; then
            echo "WARNING number after \".\" in BUILD_RELEASE in /.buildenv seems invalid as it is less than 1" >&2
        fi
        date=$(( SOURCE_DATE_EPOCH + counter ))
        echo "setting SOURCE_DATE_EPOCH_MTIME to $date" >&2
    else
        echo "WARNING could not set SOURCE_DATE_EPOCH, ensure BUILD_RELEASE is set in /.buildenv" >&2
    fi
    echo "$date"
    )"
    if test -z "$SOURCE_DATE_EPOCH_MTIME"; then
        unset SOURCE_DATE_EPOCH_MTIME
        unset SOURCE_DATE_EPOCH
    else
        export SOURCE_DATE_EPOCH_MTIME
        export SOURCE_DATE_EPOCH
    fi
    if [ -n "$SOURCE_DATE_EPOCH_MTIME" ] &&
       [ "$SOURCE_DATE_EPOCH_MTIME" -ge "$(date '+%s')" ]; then
        echo "WARNING SOURCE_DATE_EPOCH_MTIME is in the future, we assume you do not use clamping of mtime, it would fail in hard to notice ways, continuing" >&2
    fi
fi
