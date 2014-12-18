# set -x

BUILDDISTRIBUTION=$1
DEB_SOURCE_PACKAGE=`egrep '^Source: ' debian/control | cut -f 2 -d ' '`
DISTRIBUTION=`dpkg-parsechangelog | grep ^Distribution: | sed -e 's/^Distribution:\s*//'`
VERSION_UPSTREAM='0.0.6'

VERSION_DATE=`/bin/date --utc +%0Y%0m%0d`
BUILD=`/bin/date --utc +%H%M`

VERSION_FULL="${VERSION_UPSTREAM}.${VERSION_DATE}.${BUILD}"

if [ $DISTRIBUTION != 'trusty' ] ; then
        DISTRIBUTION='trusty'
else
        DISTRIBUTION='precise'
fi

if [ ! -z $BUILDDISTRIBUTION ] ; then
        DISTRIBUTION=$BUILDDISTRIBUTION
fi

ARCHTYPEN="xz:J bz2:j gz:z"
for archtyp in  ${ARCHTYPEN}
do
	arch=`echo $archtyp | cut -d: -f1`
	pack=`echo $archtyp | cut -d: -f2`
	DEBSRCPKGFILE="../${DEB_SOURCE_PACKAGE}_${VERSION_FULL}.orig.tar.${arch}"
	DEBSRCPKGFILEBAK="${DEBSRCPKGFILE}.1"

	if [ -f ${DEBSRCPKGFILE} ] ; then
		mv ${DEBSRCPKGFILE} ${DEBSRCPKGFILEBAK}
	fi

	if [ -f ${DEBSRCPKGFILE} -o -f ${DEBSRCPKGFILEBAK} ] ; then
		echo "$DEBSRCPKGFILE or $DEBSRCPKGFILEBAK exists";
		continue;
	else
#		echo "tar --exclude=.git --exclude=debian -c${pack}f ${DEBSRCPKGFILE} ${DEB_SOURCE_PACKAGE}"
#		tar --exclude=.git --exclude=debian -c${pack}f ${DEBSRCPKGFILE} ${DEB_SOURCE_PACKAGE}
#		rm -rf ${DEB_SOURCE_PACKAGE}

		dch -b -D ${DISTRIBUTION} -v "${VERSION_FULL}-0frodo0~${DISTRIBUTION}" "New upstream"
		break;
	fi
done

exit 0
