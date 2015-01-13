
## There is now a better way

[Updater](http://www.devdemon.com/expressionengine-addons/updater)


## eeupdate

Script that readies files for ExpressionEngine update. Although script is non-destructive and does not delete any files, use with caution. Always backup database before running EE update. Use on local site and tailor paths and commands to fit your needs.

The script basically follow the EE update instructions. They can be found here:
http://expressionengine.com/user_guide/installation/update.html

Instructions:
1. Backup your EE site database.
2. Download fresh EE files.
3. Store downloaded files in path as specified in script e.g.: EESOURCEPATH="/Users/kellypacker/Sites/eeupdate/eesource/"
4. Run script from root of site you want to update.
5. Enter system folder when prompted.
6. Point your browser at: http://example.com/admin.php
7. Run the EE update
8. Once the update has ran, delete the system/installer/ folder
9. Check your site to see if everything updated properly. If all has gone well, delete folders and files with the _old suffix.


