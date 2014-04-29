#!/bin/bash

#########################################
##                                     ##
## Creates Demo Project Automagically! ##
##                                     ##
#########################################

# no args need to show help.
if [ $# -ne 1 ]
then
	echo Usage: 
	echo
	echo "     `basename $0` projectname"
	echo
	exit 
fi

# create project directory.
echo
echo Created project directory.
mkdir $1
cd $1

echo 
echo Adding main readme file.

echo "JBoss $1 Quickstart Guide
============================================================

Demo based on JBoss [product-name] products.

Setup and Configuration
-----------------------

See Quick Start Guide in project as ODT and PDF for details on installation.

For those that can't wait, see README in 'installs' directory, add products, 
	run 'init.sh', read output and then read Quick Start Guide that shows you 
	how to demo.

[insert-quickstart-steps]

Released versions
-----------------

See the tagged releases for the following versions of the product:
" > README.md

# create dirs.
echo
echo Creating installs directory and readme.
mkdir installs 
echo "Download the following from the JBoss Customer Portal

* [insert-product] ([insert-product-file].zip)

and copy to this directory for the init.sh script to work.

Ensure that this file is executable by running:

chmod +x <path-to-project>/installs/[insert-product-file].zip
" > installs/README

echo
echo Creating projects directory and readme.
mkdir projects
echo "Directory to hold project." > projects/README

echo
echo Creating support files directory and readme.
mkdir support
echo "Directory to hold helper files." > support/README

echo 
echo Creating various .gitignores.
echo "target/
.DS_Store" > .gitignore
echo ".zip" > installs/.gitignore
echo ".metadata" > projects/.gitignore

echo 
echo Create init.sh for demo, named example_init.sh.

cat > example_init.sh << EOF
#!/bin/sh 
DEMO="$1 Demo"
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
	for zip in \${ZIP_FILES}
	do
		echo "Unpacking \$zip"
		unzip -q -d \${INSTALL_DIR} \$zip
	done
}

post_install () {
	echo "Running post install tasks"
	#TODO: Add your custom post_install steps here
}

###### Util functions
abort_with_error_msg () {
	echo "[ERROR] Installation has aborted with the following message: \$1"
	exit 99
}

check_zip_files_present () {
	for zip in \${ZIP_FILES}
	do
		if [ ! -f \${zip} ]; then
			abort_with_error_msg "Missing zip file \$zip, please make sure that you read the README.md file and downloaded the necessary zip files"  
		fi
	done
}

clean_if_not_empty () {
	if [ "\$(ls -A \$1)" ]; then
		rm -rf \$1/*
	fi
}

create_install_dir () {
	# Create the target directory if it does not already exist.
	if [ ! -x \${INSTALL_DIR} ]; then
		echo "  - creating the installation directory..."
		echo
		mkdir \${INSTALL_DIR}
	else
		echo "  - installation directory exists, moving on..."
		echo
		clean_if_not_empty \${INSTALL_DIR}
	fi
}

echo
echo "Setting up the ${DEMO} environment..."
echo

pre_install
install
post_install

echo "\${DEMO} Setup Complete."
echo
EOF

echo
echo You can new view your project directory setup in $1.
echo
