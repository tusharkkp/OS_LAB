#!/bin/bash

while true
do
    echo
    echo "=========================================="
    echo "     FILE AND DIRECTORY OPERATIONS"
    echo "=========================================="
    echo "1. Create a file"
    echo "2. Create a directory"
    echo "3. Display file/directory information"
    echo "4. List directory contents"
    echo "5. Copy a file"
    echo "6. Move/Rename a file"
    echo "7. Delete a file"
    echo "8. Delete an empty directory"
    echo "9. Search for a file/directory"
    echo "10. Display file size"
    echo "11. Exit"
    echo "=========================================="

    read -p "Enter your choice: " choice

    case $choice in

        # 1. Create a file
        1)
            read -p "Enter file name: " file

            if [ -e "$file" ]; then
                echo "Error: File already exists."
            elif [ -z "$file" ]; then
                echo "Error: File name cannot be empty."
            elif touch "$file"; then
                echo "File '$file' created successfully."
            else
                echo "Error: Unable to create file."
            fi
            ;;

        # 2. Create a directory
        2)
            read -p "Enter directory name: " dir

            if [ -e "$dir" ]; then
                echo "Error: File/directory already exists."
            elif [ -z "$dir" ]; then
                echo "Error: Directory name cannot be empty."
            elif mkdir "$dir"; then
                echo "Directory '$dir' created successfully."
            else
                echo "Error: Unable to create directory."
            fi
            ;;

        # 3. Display file/directory information
        3)
            read -p "Enter file/directory name: " path

            if [ -e "$path" ]; then
                stat "$path"
            else
                echo "Error: '$path' does not exist."
            fi
            ;;

        # 4. List directory contents
        4)
            read -p "Enter directory path: " dir

            if [ -d "$dir" ]; then
                ls -la "$dir"
            else
                echo "Error: Directory does not exist."
            fi
            ;;

        # 5. Copy a file
        5)
            read -p "Enter source file: " source
            read -p "Enter destination: " destination

            if [ ! -e "$source" ]; then
                echo "Error: Source file does not exist."
            elif [ ! -f "$source" ]; then
                echo "Error: Source is not a regular file."
            elif cp "$source" "$destination"; then
                echo "File copied successfully."
            else
                echo "Error: Unable to copy file."
            fi
            ;;

        # 6. Move/Rename a file
        6)
            read -p "Enter source file: " source
            read -p "Enter new name/path: " destination

            if [ ! -e "$source" ]; then
                echo "Error: Source does not exist."
            elif mv "$source" "$destination"; then
                echo "File moved/renamed successfully."
            else
                echo "Error: Unable to move/rename."
            fi
            ;;

        # 7. Delete a file
        7)
            read -p "Enter file name: " file

            if [ ! -e "$file" ]; then
                echo "Error: File does not exist."
            elif [ ! -f "$file" ]; then
                echo "Error: '$file' is not a regular file."
            elif rm "$file"; then
                echo "File deleted successfully."
            else
                echo "Error: Unable to delete file."
            fi
            ;;

        # 8. Delete an empty directory
        8)
            read -p "Enter directory name: " dir

            if [ ! -e "$dir" ]; then
                echo "Error: Directory does not exist."
            elif [ ! -d "$dir" ]; then
                echo "Error: '$dir' is not a directory."
            elif rmdir "$dir"; then
                echo "Empty directory deleted successfully."
            else
                echo "Error: Directory is not empty or cannot be deleted."
            fi
            ;;

        # 9. Search for a file/directory
        9)
            read -p "Enter directory to search in: " dir
            read -p "Enter name to search: " name

            if [ ! -d "$dir" ]; then
                echo "Error: Search directory does not exist."
            else
                result=$(find "$dir" -name "$name" 2>/dev/null)

                if [ -n "$result" ]; then
                    echo "Found:"
                    echo "$result"
                else
                    echo "File/directory not found."
                fi
            fi
            ;;

        # 10. Display file size
        10)
            read -p "Enter file/directory name: " path

            if [ -e "$path" ]; then
                stat -c "Size: %s bytes" "$path"
            else
                echo "Error: File/directory does not exist."
            fi
            ;;

        # 11. Exit
        11)
            echo "Exiting program..."
            exit 0
            ;;

        # Invalid choice
        *)
            echo "Error: Invalid choice. Enter 1-11."
            ;;

    esac
done