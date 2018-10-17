#!/bin/bash
#very simple example shell script for managing a cd cellection
#Copyright (C) 1996-207 Wiley Publishing Inc

# Copyright information
# Blah blah ...

menu_choice=""
current_cd=""
title_file="title.cdb"
tracks_file="tracks.cdg"
temp_file=/tmp/cdb.$$
trap 'rm -f $temp_file' EXIT ##ensure delete the temporary file when user input ctrl-c

## tool function to avoid repeated codes
get_return(){
    echo -e "Press Return \c"
    read x
    return 0
}

get_confirm(){
    echo -e "Are you sure? \c"
    while true
    do
        read x
        case "$x" in
            y|yes|Y|Yes|YES)
                return 0;;
            n|no|N|No|NO )
                echo
                echo "Cancelled"
                return 1;;
            *) echo "Please enter yes or no";;
        esac
    done
}

## main menu function

set_menu_choice(){
    clear
    echo "Options :-"
    echo
    echo "  a) Add new CD"
    echo "  f) Find CD"
    echo "  c) Count the CDs and tracks in the catalog"
    if [ "$cdcatnum"!="" ];then
        echo "  1) List tracks on $cdtitle"
        echo "  r) Remove $cdtitle"
        echo "  u) Update track information for $cdtitle"
    fi
    echo "  q) Quit"
    echo
    echo -e "Please enter choice then press return \c"
    read menu_choice
    return
}

## add data into the database
insert_title(){
    echo $* >> $title_file
    return
}

insert_track(){
    echo $* >> $tracks_file
}

add_record_tracks(){
    echo "Enter track information for this CD"
    echo "When no more tracks enter q"
    cdtrack=1
    cdttitle=""
    while [ "$cdttile"!="q" ]
    do
        echo -e "Track $cdtrack, track title? \c"
        read tmp
        cdttitle=${tmp%%,*}
        if [ "$tmp"!="$cdttitle" ]; then
            echo "Sorry, no commas allowed"
            continue
        fi
        if [ -n "$cdttitle" ] ; then
            if [ "$cdttitle" !="q" ]; then
                insert_track $cdcatnum,$cdtrack,$cdttitle
            fi
        else
            cdtrack=$((cdtrack-1))
        fi
    cdtrack=$((cdtrack+1))
    done
}

##input new CD header information

add_records(){
    #Prompt for the initial information
    echo -e "Enter catalog name \c"
    read tmp
    cdcatnum=${tmp%%,*}

    echo -e "Enter title \c"
    read tmp
    cdtitle=${tmp%%,*}

    echo -e "Enter type \c"
    read tmp
    cdtype=${tmp%%,*}

    echo -e "Enter artist/composer \c"
    read tmp
    cdac=${tmp%%,*}

    #check that they want to enter the information

    echo About to add new entry
    echo "$cdcatnum $cdtitle $cdtype $cdac"

#if confirmed then append it to the titles file
    if get_confirm ; then
        insert_title $cdcatnum,$cdtitle,$cdtype,$cdac
        add_record_tracks
    else
        remove_records
    fi
    return
}

#find related information about CD

find_cd(){
    if test "$1"="n"; then
        asklist=n
    else
        asklist=y
    fi
    cdcatnum=""
    echo -e "Enter a string to search for in the CD titles \c"
    read searchstr
    if test "$searchstr"=""; then
        return 0
    fi

    grep "$serachstr" $title_file > $temp_file

    set $(wc -l $temp_file)
    linesfound=$1

    case "$linesfound" in
    0)  echo "Sorry, nothing found"
        get_return
        return 0
        ;;
    1)  ;;
    2)  echo "Sorry, not unique."
        echo "Found the following"
        cat $temp_file
        get_return
        return 0;
    esac

    IFS=","
    read cdcatnum cdtitle cdtype cdac < $temp_file
    IFS=" "
    
    if test -z "$cdcatnum";then
        echo "Sorry, could not extract catalog field from $temp_file"
        get_return
        return 0
    fi

    echo
    echo Catalog number: $cdcatnum
    echo Title: $cdtitle
    echo Type: $cdtype
    echo Artist/Composer: $cdac
    echo
    get_return

    if test "$asklist"="y"; then
        echo -e "View tracks for this CD? \c"
        red x
        if test "$x"="y"; then
            echo
            list_tracks
            echo
        fi
    fi
    return 1

}

#input information about cd again

update_cd(){
    if test -z "$cdcatnum";then
        echo "You must select a CD first"
        find_cd n
    fi
    if test -n "$cdcatnum"; then
        echo "Current tracks are :-"
        list_tracks
        echo
        echo "This will re-enter the tracks for $cdtitle"
        get_confirm &&{
            grep -v "^${cdcatnum}," $tracks_file > $temp_file
                mv $temp_file $tracks_file
                echo
                add_record_tracks
        }
    fi
    return
}
## quickly statise the number of CDs and music
count_cds(){
    set $(wc -l $title_file)
    num_titles=$1
    set $(wc -l $tracks_file)
    num_tracks=$1
    echo found $num_titles CDs, with a total of $num_tracks tracks
    get_return
    return
}

##remove data
remove_records(){
    if test -z "$cdcatnum";then
        echo You must select a CD first
        find_cd n
    fi
    if test -n "$cdcatnum";then
        echo "You are about to delete $cdtitle"
        get_confirm && {
            grep -v "^${cdcatnum}," $title_file > $temp_file
            mv $temp_file $title_file
            grep -v "^${cdcatnum}," $tracks_file > $temp_file
            mv $temp_file $tracks_file
            cdcatnum=''
            echo Entry removed
        }
    get_return
        fi
        return
}

# search
list_tracks(){
    if test "$cdcatnum" =""; then
        echo no CD selected yet
            return
    else
        grep "^${cdcatnum}," $tracks_file > $temp_file
        num_trakcs=$(wc -l $temp_file)
        if test "$num_tracks"="0";then
            echo no tracks found for $cdtitle
        else {
            echo 
            echo "$cdtitle :-"
            echo
            cut -f 2- -d , $temp_file
            echo 
        } | ${PAGE: -more}
        fi
    fi
        get_return
        return

}

#main program

rm -f $temp_file
if test ! -f $title_file; then
    touch $title_file
fi

#Now the application proper
clear
echo
echo
echo "Mini CD manager"
sleep 1
quit=n
while test "$quit"!="y";do
    set_menu_choice
    case "$menu_choice" in
        a) add_records;;
        r) remove_records;;
        f) find_cd y;;
        u) update_cd;;
        c) count_cds;;
        l) list_tracks;;
        b)
            echo
            more $title_file
            echo 
            get_return;;
        q|Q) quit=y;;
        *) echo "Sorry, choice not recognized";;
        esac
done

#tidy up and leave
rm -f $temp_file
echo "Finished"
exit 0
