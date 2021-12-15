# https://github.com/MarcinKonowalczyk/run_sh
# Bash script run by a keboard shortcut, called with rteh current file path $1
# This is intended as an exmaple, but also contains a bunch of useful path partitions
# Feel free to delete everything in here and make it do wahtever you want.

echo "Hello from run script! ^_^"

# The direcotry of the main project from which this script is running
# https://stackoverflow.com/a/246128/2531987
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT="${ROOT%/*}" # Strip .vscode folder
NAME="${ROOT##*/}" # Project name
PWD=$(pwd);

# Extension, filename and directory parts of the file which triggered this
# http://mywiki.wooledge.org/BashSheet#Parameter_Operations
FILE="$1"
FILENAME="${FILE##*/}" # Filename with extension
FILEPATH="${FILE%/*}" # Path of the current file
FILEFOLDER="${FILEPATH##*/}" # Folder in which the current file is located (could be e.g. a nested subdirectory)
EXTENSION="${FILENAME##*.}" # Just the extension
ROOTFOLDER="${1##*$ROOT/}" && ROOTFOLDER="${ROOTFOLDER%%/*}" # folder in the root directory (not necesarilly the same as FILEFOLDER)
[ $ROOTFOLDER != $FILENAME ] || ROOTFOLDER=""

# Echo of path variables
# VERBOSE=true
VERBOSE=false
[ "$FILEFOLDER" = ".vscode" ] && [ "$FILENAME" = "run.sh" ] && VERBOSE=true

if $VERBOSE; then
    # https://stackoverflow.com/a/5947802/2531987
    GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m'

    LOGO=true
    if $LOGO; then
        PURPLE='\033[0;34m'; DARKGRAY='\033[1;30m';
        TEXT=(
            " ______   __  __   __   __ " "    " "    ______   __  __   "
            "/\\  == \\ /\\ \\/\\ \\ /\\ \"-.\\ \\ " "    " "  /\\  ___\\ /\\ \\_\\ \\  "
            "\\ \\  __< \\ \\ \\_\\ \\\\\\ \\ \\-.  \\ " "  __" " \\ \\___  \\\\\\ \\  __ \\ "
            " \\ \\_\\ \\_\\\\\\ \\_____\\\\\\ \\_\\\\\\\"\\_\\ " "/\\_\\\\" " \\/\\_____\\\\\\ \\_\\ \\_\\\\"
            "  \\/_/ /_/ \\/_____/ \\/_/ \\/_/ " "\\/_/" "  \\/_____/ \\/_/\\/_/"
        )
        echo -e "$PURPLE${TEXT[0]}$DARKGRAY${TEXT[1]}$PURPLE${TEXT[2]}$NC"
        echo -e "$PURPLE${TEXT[3]}$DARKGRAY${TEXT[4]}$PURPLE${TEXT[5]}$NC"
        echo -e "$PURPLE${TEXT[6]}$DARKGRAY${TEXT[7]}$PURPLE${TEXT[8]}$NC"
        echo -e "$PURPLE${TEXT[9]}$DARKGRAY${TEXT[10]}$PURPLE${TEXT[11]}$NC"
        echo -e "$PURPLE${TEXT[12]}$DARKGRAY${TEXT[13]}$PURPLE${TEXT[14]}$NC"
        echo -e ""
    fi

    echo -e "ROOT       : $GREEN${ROOT}$NC  # root directory of the project"
    echo -e "NAME       : $GREEN${NAME}$NC  # project name"
    echo -e "PWD        : $GREEN${PWD}$NC  # pwd"
    echo -e "FILE       : $GREEN${FILE}$NC # full file information"
    echo -e "FILENAME   : $GREEN${FILENAME}$NC  # current filename"
    echo -e "FILEPATH   : $GREEN${FILEPATH}$NC  # path of the current file"
    echo -e "FILEFOLDER : $GREEN${FILEFOLDER}$NC  # folder in which the current file is located"
    echo -e "EXTENSION  : $GREEN${EXTENSION}$NC  # just the extension of the current file"
    if [ $ROOTFOLDER ]; then
        if [ $ROOTFOLDER != $FILEFOLDER ]; then
            echo -e "ROOTFOLDER : $GREEN${ROOTFOLDER}$NC # folder in the root directory"
        else
            echo -e "ROOTFOLDER : ${YELLOW}<same as FILEFOLDER>${NC}"
        fi
    else
        echo -e "ROOTFOLDER : ${YELLOW}<file in ROOT>${NC}"
    fi
fi

##################################################

if [ "$EXTENSION" = "jl" ]; then
    julia "$FILE"
elif [ "$EXTENSION" = "js" ]; then
    node "$FILE"
elif [ "$EXTENSION" = "java" ]; then
    JAVAC_ARGS="-Xdiags:verbose -Xmaxerrs 1"
    javac "$FILE" $JAVAC_ARGS && java "${FILENAME%.*}" && rm "${FILENAME%.*}.class"
elif [ "$EXTENSION" = "jelly" ]; then
    # cat "$FILENAME" | head -n1 | sed -r 's/(“\.?\/?|»)//g' | sed "s/^/${ROOT//\//\\/}\//" | xargs cat | jelly fu "$FILENAME"
    DATA=$(cat "$FILENAME" | head -n1 | sed -r 's/(“\.?\/?|»)//g' | sed "s/^/${ROOT//\//\\/}\//") # get data filename from the file ( firt line of teh input)
    LINES=$(cat $DATA | wc -l); LINES=$((LINES+1)); # get lines count of the data file
    cat "$DATA" | jelly fu "$FILENAME" "$LINES" # pass the content of the file as stdin and the number of lines as argv3 to the jelly script
elif [ "$EXTENSION" = "jq" ]; then
    # Find comment lines with '# data = ' and '# flags = ' specofying the data file and flags to use
    DATA_FILE=$(cat "$FILENAME" | sed -nr '/^# *data *=[^=] *[^ ].*/p' | sed -r "s/# *data *=[^=] *\.?\/?//g; s/^/${ROOT//\//\\/}\//")
    JQ_FLAGS=$(cat "$FILENAME" | sed -nr '/^# *flags *=[^=] *[^ ].*/p' | sed -r 's/# *flags *=[^=] *\.?\/?//g')
    # echo "DATA_FILE = $DATA_FILE"; echo "JQ_FLAGS  = $JQ_FLAGS";
    cat "$DATA_FILE" | jq "$JQ_FLAGS" --from-file "$FILENAME"
fi