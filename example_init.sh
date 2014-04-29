#!/bin/sh 
DEMO="Test Demo"
#TODO: Add zip file(s) that should be unpacked as part of the installation
ZIP_FILES=""
INSTALL_DIR=./target

pre_install () {
	echo "Running pre install tasks"
	check_zip_files_present
	create_install_dir
	#TODO: Add your custom pre_install steps here
}

install () {
	for zip in ${ZIP_FILES}
	do
		echo "Unpacking $zip"
		unzip -q -d ${INSTALL_DIR} $zip
	done
}

post_install () {
	echo "Running post install tasks"
	#TODO: Add your custom post_install steps here
}

###### Util functions
abort_with_error_msg () {
	echo "[ERROR] Installation has aborted with the following message: $1"
	exit 99
}

check_zip_files_present () {
	for zip in ${ZIP_FILES}
	do
		if [ ! -f ${zip} ]; then
			abort_with_error_msg "Missing zip file $zip, please make sure that you read the README.md file and downloaded the necessary zip files"  
		fi
	done
}

clean_if_not_empty () {
	if [ "$(ls -A $1)" ]; then
		rm -rf $1/*
	fi
}

create_install_dir () {
	# Create the target directory if it does not already exist.
	if [ ! -x ${INSTALL_DIR} ]; then
		echo "  - creating the installation directory..."
		echo
		mkdir ${INSTALL_DIR}
	else
		echo "  - installation directory exists, moving on..."
		echo
		clean_if_not_empty ${INSTALL_DIR}
	fi
}

echo
echo "Setting up the  environment..."
echo

pre_install
install
post_install

echo "${DEMO} Setup Complete."
echo
