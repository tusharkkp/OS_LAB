#!/bin/bash

# ------------------------------------------------------------
# Default warning threshold
# ------------------------------------------------------------

THRESHOLD=80


# ------------------------------------------------------------
# Function: Validate Threshold
# ------------------------------------------------------------

validate_threshold()
{
    local value="$1"

    # Check whether the value contains only digits
    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
        echo
        echo "ERROR: Threshold must be a numeric value."
        return 1
    fi

    # Check whether threshold is between 1 and 100
    if [ "$value" -lt 1 ] || [ "$value" -gt 100 ]; then
        echo
        echo "ERROR: Threshold must be between 1 and 100."
        return 1
    fi

    return 0
}


# ------------------------------------------------------------
# Function: Display Complete Table
# ------------------------------------------------------------

display_all()
{
    echo
    echo "=========================================================================="
    echo "                    COMPLETE DISK USAGE TABLE"
    echo "=========================================================================="
    echo "Warning Threshold: ${THRESHOLD}%"
    echo

    printf "%-25s %-10s %-10s %-12s %-10s %-25s\n" \
        "FILE SYSTEM" \
        "TOTAL" \
        "USED" \
        "AVAILABLE" \
        "USE%" \
        "MOUNT POINT"

    echo "----------------------------------------------------------------------------------------------"

    # df -hP:
    # -h = human-readable sizes
    # -P = POSIX format for reliable processing
    #
    # tail removes the header line from df output.

    df -hP | tail -n +2 |
    while read -r filesystem total used available percentage mountpoint
    do

        # Remove '%' from usage percentage
        usage=${percentage%\%}

        printf "%-25s %-10s %-10s %-12s %-10s %-25s\n" \
            "$filesystem" \
            "$total" \
            "$used" \
            "$available" \
            "$percentage" \
            "$mountpoint"

    done

    echo "----------------------------------------------------------------------------------------------"

    # Display warnings separately
    display_warnings

    echo "=========================================================================="
}


# ------------------------------------------------------------
# Function: Select Columns
# ------------------------------------------------------------

select_columns()
{
    local selection

    echo
    echo "============================================================"
    echo "                 SELECT COLUMNS"
    echo "============================================================"
    echo
    echo "1. File System Name"
    echo "2. Total Space"
    echo "3. Used Space"
    echo "4. Available Space"
    echo "5. Usage Percentage"
    echo "6. Mount Point"
    echo "7. Select All"
    echo "8. Back"
    echo

    read -p "Enter column numbers separated by spaces: " selection

    # Handle Back option
    if [[ "$selection" == "8" ]]; then
        return
    fi

    # Select all columns
    if [[ "$selection" == "7" ]]; then
        show_fs=1
        show_total=1
        show_used=1
        show_available=1
        show_usage=1
        show_mount=1

    else

        # Reset column selection
        show_fs=0
        show_total=0
        show_used=0
        show_available=0
        show_usage=0
        show_mount=0

        # Process each selected column
        for choice in $selection
        do
            case "$choice" in
                1) show_fs=1 ;;
                2) show_total=1 ;;
                3) show_used=1 ;;
                4) show_available=1 ;;
                5) show_usage=1 ;;
                6) show_mount=1 ;;

                *)
                    echo
                    echo "ERROR: Invalid column number: $choice"
                    return
                    ;;
            esac
        done
    fi

    # Make sure at least one column is selected
    if [ "$show_fs" -eq 0 ] &&
       [ "$show_total" -eq 0 ] &&
       [ "$show_used" -eq 0 ] &&
       [ "$show_available" -eq 0 ] &&
       [ "$show_usage" -eq 0 ] &&
       [ "$show_mount" -eq 0 ]; then

        echo
        echo "ERROR: Please select at least one column."
        return
    fi


    # --------------------------------------------------------
    # Display Selected Columns
    # --------------------------------------------------------

    echo
    echo "=========================================================================="
    echo "                    SELECTED DISK INFORMATION"
    echo "=========================================================================="
    echo "Warning Threshold: ${THRESHOLD}%"
    echo

    # Header

    if [ "$show_fs" -eq 1 ]; then
        printf "%-25s" "FILE SYSTEM"
    fi

    if [ "$show_total" -eq 1 ]; then
        printf "%-12s" "TOTAL"
    fi

    if [ "$show_used" -eq 1 ]; then
        printf "%-12s" "USED"
    fi

    if [ "$show_available" -eq 1 ]; then
        printf "%-12s" "AVAILABLE"
    fi

    if [ "$show_usage" -eq 1 ]; then
        printf "%-10s" "USE%"
    fi

    if [ "$show_mount" -eq 1 ]; then
        printf "%-25s" "MOUNT POINT"
    fi

    echo
    echo "--------------------------------------------------------------------------"


    # --------------------------------------------------------
    # Read and display dynamic filesystem information
    # --------------------------------------------------------

    df -hP | tail -n +2 |
    while read -r filesystem total used available percentage mountpoint
    do

        usage=${percentage%\%}

        if [ "$show_fs" -eq 1 ]; then
            printf "%-25s" "$filesystem"
        fi

        if [ "$show_total" -eq 1 ]; then
            printf "%-12s" "$total"
        fi

        if [ "$show_used" -eq 1 ]; then
            printf "%-12s" "$used"
        fi

        if [ "$show_available" -eq 1 ]; then
            printf "%-12s" "$available"
        fi

        if [ "$show_usage" -eq 1 ]; then
            printf "%-10s" "$percentage"
        fi

        if [ "$show_mount" -eq 1 ]; then
            printf "%-25s" "$mountpoint"
        fi

        echo

    done

    echo "--------------------------------------------------------------------------"

    display_warnings

    echo "=========================================================================="
}


# ------------------------------------------------------------
# Function: Display Warning Filesystems
# ------------------------------------------------------------

display_warnings()
{
    local warning_found=0

    echo
    echo "                    THRESHOLD CHECK"
    echo "--------------------------------------------------------------------------"

    printf "%-25s %-10s %-25s\n" \
        "FILE SYSTEM" \
        "USE%" \
        "MOUNT POINT"

    echo "--------------------------------------------------------------------------"

    # Temporary variable is used so that the loop output remains
    # easy to understand and process.

    while read -r filesystem total used available percentage mountpoint
    do

        usage=${percentage%\%}

        if [ "$usage" -gt "$THRESHOLD" ]; then

            printf "%-25s %-10s %-25s\n" \
                "$filesystem" \
                "$percentage" \
                "$mountpoint"

            warning_found=1

        fi

    done < <(df -hP | tail -n +2)


    if [ "$warning_found" -eq 0 ]; then
        echo "No filesystem exceeds the ${THRESHOLD}% threshold."
    else
        echo
        echo "WARNING: One or more filesystems exceed the threshold!"
    fi

    echo "--------------------------------------------------------------------------"
}


# ------------------------------------------------------------
# Function: Change Threshold
# ------------------------------------------------------------

change_threshold()
{
    local new_threshold

    echo
    echo "============================================================"
    echo "                 CHANGE THRESHOLD"
    echo "============================================================"
    echo
    echo "Current Threshold: ${THRESHOLD}%"
    echo

    read -p "Enter new threshold (1-100): " new_threshold

    if validate_threshold "$new_threshold"; then

        THRESHOLD="$new_threshold"

        echo
        echo "SUCCESS: Warning threshold changed to ${THRESHOLD}%."

    fi
}


# ------------------------------------------------------------
# Main Menu
# ------------------------------------------------------------

while true
do

    clear

    echo "============================================================"
    echo "              DISK SPACE USAGE MONITOR"
    echo "============================================================"
    echo
    echo "Current Warning Threshold : ${THRESHOLD}%"
    echo
    echo "1. Display Complete Disk Usage Table"
    echo "2. Select Columns to Display"
    echo "3. Change Warning Threshold"
    echo "4. Display Filesystems Above Threshold"
    echo "5. Exit"
    echo
    echo "============================================================"

    read -p "Enter your choice [1-5]: " choice


    case "$choice" in

        1)
            display_all
            read -p "Press Enter to return to menu..."
            ;;

        2)
            select_columns
            read -p "Press Enter to return to menu..."
            ;;

        3)
            change_threshold
            read -p "Press Enter to return to menu..."
            ;;

        4)
            display_warnings
            read -p "Press Enter to return to menu..."
            ;;

        5)
            clear
            echo "============================================================"
            echo "       Disk Space Monitoring Completed Successfully"
            echo "============================================================"
            exit 0
            ;;

        *)
            echo
            echo "ERROR: Invalid choice."
            echo "Please select an option between 1 and 5."
            read -p "Press Enter to continue..."
            ;;

    esac

done
