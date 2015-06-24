function _fancy_prompt {
  local RED="\[\033[31m\]"
  local GREEN="\[\033[32m\]"
  local YELLOW="\[\033[33m\]"
  local BLUE="\[\033[01;34m\]"
  local WHITE="\[\033[00m\]"
  local LIGHTBLUE="\[\033[36m\]"

  # Show Virtualenv directory
  if [[ -n "$VIRTUAL_ENV" ]]
  then
    venv="(${VIRTUAL_ENV##*/})"
  else
    venv=""
  fi
  local PROMPT=$venv

  # Show current user and hostname
  PROMPT=$PROMPT"$LIGHTBLUE[\u@\h] "

  # Path abbreviation
  local pwd_length=35
  local pwd_symbol="..."
  local newPWD="${PWD/#$HOME/~}"

  if [ $(echo -n $newPWD | wc -c | tr -d " ") -gt $pwd_length ]
  then
	  newPWD=$(echo -n $newPWD | awk -F '/' '{if (NF>4) { 
    print $1 "/" $2 "/.../" $(NF-1) "/" $(NF)} 
    else {
	    print $PWD}}')
  fi
  
  PROMPT=$PROMPT"$YELLOW$newPWD"

  # Git-specific
  local GIT_STATUS=$(git status 2> /dev/null)
  if [ -n "$GIT_STATUS" ] # Are we in a git directory?
  then
    # Open paren
    PROMPT=$PROMPT" $RED("

    # Branch
    PROMPT=$PROMPT$(git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")

    # Warnings
    PROMPT=$PROMPT$YELLOW

    # Merging
    echo $GIT_STATUS | grep "Unmerged paths" > /dev/null 2>&1
    if [ "$?" -eq "0" ]
    then
      PROMPT=$PROMPT"|MERGING"
    fi

    # Dirty flag
    echo $GIT_STATUS | grep "nothing to commit" > /dev/null 2>&1
    if [ "$?" -eq 0 ]
    then
      PROMPT=$PROMPT
    else
      PROMPT=$PROMPT"*"
    fi
 
    # Warning for no email setting
    git config user.email | grep @ > /dev/null 2>&1
    if [ "$?" -ne 0 ]
    then
      PROMPT=$PROMPT" !!! NO EMAIL SET !!!"
    fi

    # Closing paren
    PROMPT=$PROMPT"$RED)"
  fi

  # Final $ symbol
  PROMPT=$PROMPT"$BLUE\$$WHITE "

  export PS1=$PROMPT
}

export PROMPT_COMMAND="_fancy_prompt"




