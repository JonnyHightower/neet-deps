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
		echo "sbg=${NEET}/pkg/bin/sbg" >> "${CONFDIR}/locations"
	fi

	Install tnsenum TNSEnum
	if [ $? -eq 0 ]; then
		echo "tnsenum=${NEET}/pkg/bin/tnsenum" >> "${CONFDIR}/locations"
	fi

	if ! type openvas-nasl >/dev/null 2>&1; then
		if ! type nasl >/dev/null 2>&1; then
			Install openvas-libraries "OpenVAS Libraries"
			if [ $? -eq 0 ]; then
				OV=`type openvas-nasl 2>/dev/null | awk {print'$3'}`
				echo "openvas-nasl=$OV" >> "${CONFDIR}/locations"
			fi
		else
			OV=`type nasl | awk {print'$3'}`
			echo "openvas-nasl=$OV" >> "${CONFDIR}/locations"
		fi
	else
		OV=`type openvas-nasl | awk {print'$3'}`
		echo "openvas-nasl=$OV" >> "${CONFDIR}/locations"
	fi

	if ! type amap >/dev/null 2>&1; then
		Install amap "THC Amap"
		if [ $? -eq 0 ]; then
			echo "amap=${NEET}/pkg/bin/amap " >> "${CONFDIR}/locations"
		fi
	else
		OV=`type amap | awk {print'$3'}`
		echo "amap=$OV" >> "${CONFDIR}/locations"
	fi

	PkgInstall moriarty "Moriarty_Oracle_Enumeration"

	Install on On
	if [ $? -eq 0 ]; then
		echo "on=${NEET}/pkg/bin/on" >> "${CONFDIR}/locations"
	fi

	PkgInstall framework2 "Metasploit_Framework 2"

	#######################################################
	newVersion neet-deps $VERSION
else
	echo "This package is for the neet-update script and should not be installed manually."
	exit 1
fi

exit 0


