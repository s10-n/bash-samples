#!/usr/bin/bash

# autosave_cleanup - removes pesky emacs autosave files (easily identifiable based on their filename ending in a ~

backup_files=$(find . -name '*~')

file_count=0

for path in $backup_files
do
    let file_count+=1
done

read -p "Delete $file_count emacs backup files? (y/n) " user_response
if [ $user_response = y ];
then
    rm $backup_files
else
    rm $backup_files -i
fi
