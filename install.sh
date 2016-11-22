#!/bin/bash

export NEET=/opt/neet
export CONFIDR="${NEET}/etc"
export VERSION=`cat VERSION`
export INST="${PWD}"

if [ ! -d "$NEET" ]; then
	echo "Couldn't find neet installation. Exiting."
	exit 1
fi

. ${NEET}/core/installsupport

if [ ! -z $INVOKEDBYNEETUPDATE ] && [ $INVOKEDBYNEETUPDATE -eq 1 ]; then
	FILESTOREMOVE=""
	for file in $FILESTOREMOVE; do
		rm -f "$file"
	done
	echo "   + Installing neet dependency package updates..."
	#######################################################

	Install sbg SBG
	if [ $? -eq 0 ]; then
		newLocation sbg "${NEET}/pkg/bin/sbg"
	fi

	Install tnsenum TNSEnum
	if [ $? -eq 0 ]; then
		newLocation tnsenum "${NEET}/pkg/bin/tnsenum"
	fi

	Install libesedb libesedb
	if [ $? -eq 0 ]; then
		newLocation esedbexport "${NEET}/pkg/bin/esedbexport"
		PkgInstall ntdsxtract ntdsxtract
	fi

	PkgInstall creddump creddump
	newLocation pwdump "${NEET}/pkg/creddump/pwdump.py"
	newLocation lsadump "${NEET}/pkg/creddump/lsadump.py"
	newLocation cachedump "${NEET}/pkg/creddump/cachedump.py"

	if ! type amap >/dev/null 2>&1; then
		Install amap "THC Amap"
		if [ $? -eq 0 ]; then
			newLocation amap "${NEET}/pkg/bin/amap"
		fi
	else
		OV=`type amap | awk {print'$3'}`
		newLocation amap "$OV"
	fi

	PkgInstall moriarty "Moriarty_Oracle_Enumeration"

	Install on On
	if [ $? -eq 0 ]; then
		newLocation on "${NEET}/pkg/bin/on"
	fi

	PkgInstall framework2 "Metasploit_Framework 2"

	Install dirb221 "DIRB_Directory_Brute_Force"
	newLocation dirb "${NEET}/pkg/bin/dirb"

	if ! systemHas openvas-nasl; then
		Install openvas-libraries-8.0.8 "OpenVAS_NASL"	
		if [ $? -eq 0 ]; then
			newLocation openvas-nasl "${NEET}/pkg/bin/openvas-nasl"
		fi
	else
		OV=`type openvas-nasl | awk {print'$3'}`
		newLocation openvas-nasl "$OV"
	fi

	if ! systemHas winexe; then
		Install winexe-1.00 "Winexe"
		if [ $? -eq 0 ]; then
			newLocation winexe "${NEET}/pkg/bin/winexe"
		fi
	else
		OV=`type winexe | awk {print'$3'}`
		newLocation winexe "$OV"
	fi

	# Perl dependencies
	cd "${INST}/content/" && ./install_perl.sh
	cd "${INST}"

	#######################################################
	newVersion neet-deps $VERSION
else
	echo "This package is for the neet-update script and should not be installed manually."
	exit 1
fi

exit 0



