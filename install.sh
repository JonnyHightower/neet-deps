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
		#echo "sbg=${NEET}/pkg/bin/sbg" >> "${CONFDIR}/locations"
		newLocation sbg "${NEET}/pkg/bin/sbg"
	fi

	Install tnsenum TNSEnum
	if [ $? -eq 0 ]; then
		#echo "tnsenum=${NEET}/pkg/bin/tnsenum" >> "${CONFDIR}/locations"
		newLocation tnsenum "${NEET}/pkg/bin/tnsenum"
	fi

	Install libesedb libesedb
	if [ $? -eq 0 ]; then
		#echo "esedbexport=${NEET}/pkg/bin/esedbexport" >> "${CONFDIR}/locations"
		newLocation esedbexport "${NEET}/pkg/bin/esedbexport"
		# Now do ntdsxtract
		PkgInstall ntdsxtract ntdsxtract
	fi

	PkgInstall creddump creddump
	newLocation pwdump "${NEET}/pkg/creddump/pwdump.py"
	newLocation lsadump "${NEET}/pkg/creddump/lsadump.py"
	newLocation cachedump "${NEET}/pkg/creddump/cachedump.py"

	#echo "pwdump=${NEET}/pkg/creddump/pwdump.py " >> "${CONFDIR}/locations"
	#echo "lsadump=${NEET}/pkg/creddump/lsadump.py " >> "${CONFDIR}/locations"
	#echo "cachedump=${NEET}/pkg/creddump/cachedump.py " >> "${CONFDIR}/locations"

	if ! type amap >/dev/null 2>&1; then
		Install amap "THC Amap"
		if [ $? -eq 0 ]; then
			#echo "amap=${NEET}/pkg/bin/amap " >> "${CONFDIR}/locations"
			newLocation amap "${NEET}/pkg/bin/amap"
		fi
	else
		OV=`type amap | awk {print'$3'}`
		#echo "amap=$OV" >> "${CONFDIR}/locations"
		newLocation amap "$OV"
	fi

	PkgInstall moriarty "Moriarty_Oracle_Enumeration"

	Install on On
	if [ $? -eq 0 ]; then
		#echo "on=${NEET}/pkg/bin/on" >> "${CONFDIR}/locations"
		newLocation on "${NEET}/pkg/bin/on"
	fi

	PkgInstall framework2 "Metasploit_Framework 2"

	Install dirb221 "DIRB_Directory_Brute_Force"
	#echo "dirb=${NEET}/pkg/bin/dirb " >> "${CONFDIR}/locations"
	newLocation dirb "${NEET}/pkg/bin/dirb"

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



