#!/bin/bash 
while true 
do 
    echo 
    echo "--------------------------------------------------" 
    echo "        File System Permissions" 
    echo "--------------------------------------------------" 
    echo "1. Check file/directory permissions" 
    echo "2. Check ownership" 
    echo "3. Set read permission" 
    echo "4. Set write permission" 
    echo "5. Set execute permission" 
    echo "6. Remove read permission" 
    echo "7. Remove write permission" 
    echo "8. Remove execute permission" 
    echo "9. Set custom permissions" 
    echo "10. Exit" 
    echo "------------------------------------------------- " 
 
    read -p "Enter your choice: " choice 
 
    case $choice in 
 
        1) 
            # Check permissions 
            read -p "Enter file/directory path: " path 
 
            if [ -e "$path" ]; then 
                echo 
                echo "Permission information:" 
                echo "--------------------------------------------------" 
                ls -ld "$path" 
                echo "--------------------------------------------------" 
            else 
                echo "Error: File or directory does not exist." 
            fi 
            ;; 
 
        2) 
            # Check ownership 
            read -p "Enter file/directory path: " path 
 
            if [ -e "$path" ]; then 
                echo 
                echo "Ownership information:" 
                echo "--------------------------------------------------" 
                stat -c "Owner : %U 
Group : %G" "$path" 
                echo "--------------------------------------------------" 
            else 
                echo "Error: File or directory does not exist." 
            fi 
            ;; 
 
        3) 
            # Set read permission 
            read -p "Enter file/directory path: " path 
 
            if [ -e "$path" ]; then 
                chmod u+r "$path" 
                echo "Read permission granted to the owner." 
            else 
                echo "Error: File or directory does not exist." 
            fi 
            ;; 
 
        4) 
            # Set write permission 
            read -p "Enter file/directory path: " path 
 
            if [ -e "$path" ]; then 
                chmod u+w "$path" 
                echo "Write permission granted to the owner." 
            else 
                echo "Error: File or directory does not exist." 
            fi 
            ;; 
 
        5) 
            # Set execute permission 
            read -p "Enter file/directory path: " path 
 
            if [ -e "$path" ]; then 
                chmod u+x "$path" 
                echo "Execute permission granted to the owner." 
            else 
                echo "Error: File or directory does not exist." 
            fi 
            ;; 
 
        6) 
            # Remove read permission 
            read -p "Enter file/directory path: " path 
 
            if [ -e "$path" ]; then 
                chmod u-r "$path" 
                echo "Read permission removed from the owner." 
            else 
                echo "Error: File or directory does not exist." 
            fi 
            ;; 
 
        7) 
            # Remove write permission 
            read -p "Enter file/directory path: " path 
 
            if [ -e "$path" ]; then 
                chmod u-w "$path" 
                echo "Write permission removed from the owner." 
            else 
                echo "Error: File or directory does not exist." 
            fi 
            ;; 
 
        8) 
            # Remove execute permission 
            read -p "Enter file/directory path: " path 
 
            if [ -e "$path" ]; then 
                chmod u-x "$path" 
                echo "Execute permission removed from the owner." 
            else 
                echo "Error: File or directory does not exist." 
            fi 
            ;; 
 
        9) 
            # Set custom permissions 
            read -p "Enter file/directory path: " path 
            read -p "Enter permission mode (example: 755): " permission 
 
            if [ ! -e "$path" ]; then 
                echo "Error: File or directory does not exist." 
            elif [[ ! "$permission" =~ ^[0-7]{3}$ ]]; then 
                echo "Error: Enter a valid three-digit permission mode." 
            else 
                chmod "$permission" "$path" 
                echo "Permissions changed to $permission." 
            fi 
            ;; 
 
        10) 
            echo "Exiting Permission Manager..." 
            exit 0 
            ;; 
 
        *) 
            echo "Invalid choice. Please enter a number between 1 and 10." 
            ;; 
 
    esac 
done