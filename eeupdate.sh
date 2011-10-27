#!/bin/bash
# File:        eeupdate.sh
# Description: Readies files for an ExpressionEngine Update
#
# Copyright 2011 Kelly Packer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Instructions: Run from the root of the site that is being updated
# Be sure to backup your database before you run EE update

# Get the working directory
DIR=$(pwd)

# Specify where you want fresh EE files to be located
# Download the latest EE files and put them in a folder 
EESOURCEPATH="/Users/kellypacker/Sites/eeupdate/eesource/"

# The default ExpressionEngine system folder
DEFAULT="system"

# The message shown if we can't find a file / folder
ERROR_MESSAGE="Not found so no action taken:"

# Ask for system folder name
printf "Enter your system folder name (default: system):\n" 
read SYSTEM_FOLDER

# If no value is entered set default
if [ "$SYSTEM_FOLDER" == "" ] 
then
    SYSTEM_FOLDER=$DEFAULT
fi

# Check if system folder exists as entered by user
if [[ -a $SYSTEM_FOLDER ]]
then
	echo "System folder found"
else 
	echo "System folder was not found. Double check spelling and try again."
	exit
fi

# Check if old ee files exisit and the new ee files are in the source directory as set above
# Rename sites files with an _old suffix
if [[ -a admin.php ]] && [[ -a index.php ]] && [[ -a $SYSTEM_FOLDER ]] && [[ -a themes ]] && [[ -a ${EESOURCEPATH}system ]]
then 
	mv admin.php admin_old.php 
	mv index.php index_old.php
	mv $SYSTEM_FOLDER ${SYSTEM_FOLDER}_old
	mv themes themes_old
	echo "Old files renamed"
else
	echo "One or more of the following do not exist: admin.php, index.php, system dir, themes dir. /n Make sure the new ee files are in the Soure directory as set in the script and you are running the script from the root of the site you want to update."
	exit
fi

# Copy over fresh EE files from source folder
cp -R ${EESOURCEPATH}system $DIR
cp -R ${EESOURCEPATH}themes $DIR
cp -R ${EESOURCEPATH}index.php $DIR
cp -R ${EESOURCEPATH}admin.php $DIR
echo "Files copied from update folder"

# Rename new system folder to old system folder name
mv system/ $SYSTEM_FOLDER

# Get text to change in admin.php and index.php
ADMIN_SYSTEM_ORG="\$system_path = '.\/system'"
ADMIN_SYSTEM_RPL="\$system_path = '.\/"$SYSTEM_FOLDER"'"

# Change system_path string in index.php
# Did you make other changes to index.php or admin.php? Copy over changes manually or add code to edit files
sed -i "" "s/$ADMIN_SYSTEM_ORG/$ADMIN_SYSTEM_RPL/g" index.php
# Change system_path string in admin.php
sed -i "" "s/$ADMIN_SYSTEM_ORG/$ADMIN_SYSTEM_RPL/g" admin.php
echo "System folder name updated in index.php and admin.php"

# Copy files from old system folder to new
cp -f ${SYSTEM_FOLDER}_old/expressionengine/config/config.php $SYSTEM_FOLDER/expressionengine/config/config.php
cp -f ${SYSTEM_FOLDER}_old/expressionengine/config/database.php $SYSTEM_FOLDER/expressionengine/config/database.php
cp -Rf ${SYSTEM_FOLDER}_old/expressionengine/templates/ $SYSTEM_FOLDER/expressionengine/templates/
# mv safecracker_file temporarily 
mv -f $SYSTEM_FOLDER/expressionengine/third_party/safecracker_file/ $SYSTEM_FOLDER/expressionengine/
# copy old system/third_party folder to new
cp -Rf ${SYSTEM_FOLDER}_old/expressionengine/third_party/ $SYSTEM_FOLDER/expressionengine/third_party/
# remove old safecracker_file
rm -Rf $SYSTEM_FOLDER/expressionengine/third_party/safecracker_file/
#mv safecracker file back to third_party dir
mv -f $SYSTEM_FOLDER/expressionengine/safecracker_file/ $SYSTEM_FOLDER/expressionengine/third_party/

# Delete new themes/third_party 
rm -Rf themes/third_party
# Copy over old themes/third_party
mv -f themes_old/third_party themes/
echo "Themes, templates and third_party folders copied from old site"

# Set permissions
# Declare files and folders as arrays
FILES_666[0]=$DIR/$SYSTEM_FOLDER/expressionengine/config/config.php 
FILES_666[1]=$DIR/$SYSTEM_FOLDER/expressionengine/config/database.php 
DIRS_777[6]=$DIR/$SYSTEM_FOLDER/expressionengine/cache/

# Check files exist and change permissions
for FILE in ${FILES_666[@]}
do
    if [ -e $FILE ]
    then
        chmod 666 $FILE
    else
        printf "$ERROR_MESSAGE $FILE\n"
    fi
done

# Check directories exist and change permissions
for DIR in ${DIRS_777[@]}
do
    if [ -d $DIR ]
    then
        chmod -R 777 $DIR
    else
        printf "$ERROR_MESSAGE $DIR\n"
    fi
done

echo "Permissions set"