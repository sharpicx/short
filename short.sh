#!/bin/env bash
# personal tool of shortening link by sharpicx

# colors 
reset="\033[1:0m" #reset color njing
red="\033[1:31m" #merah
blue="\033[1:34m" # biru
kuning="\033[1:35m" # yellow gais
back_red="\033[1:41m" # merah background
back_blue="\033[1:44m" # biru background
black="\033[1:30m" # warna item
white="\033[1:107m" # warna putih
green="\033[1:36m"
pink="\033[1:32m"

# data
selected_elements="div#main"
removed_elements="div#createformlabel, form, input.submitbutton, hr, div#qrmessage, p, b, div#origurl, img, br, a"
sed_elements='s/[\",>]//g'

echo -e "${pink}1. shorten a link${reset}"
echo -e "${pink}2. my recently shortened link${reset}"
echo -e "${pink}?. Enter anything to exit${reset}" && echo ''
read -p $'\e[1:34m[choose option 1-2]:\e[1m ' answer
if [[ "$answer" == "1" ]]; then
  read -p $'\e[1:34mgive me a link to be shortened:\e[1m ' link
  if [[ "$link" == "$(echo $link | grep -w ^https)" || "$link" == "$(echo $link | grep -w ^http)" ]]; then
    output=$(curl -sX POST 'https://is.gd/create.php' -d "url=$link&submit='Shorten!'")
    cleaned_output=$(echo $output | hxnormalize -x | hxselect -c "$selected_elements" | hxremove -i "$removed_elements" | tr -d '\n[:blank:]' | cut -f7 -d "=" | sed "$sed_elements")
    echo -e "${pink}your shortened link is: ${green}$cleaned_output${reset}${reset}"
    #python -c "import requests; 
  else
    echo -e "${red}invalid url.${reset}"
  fi
elif [[ "$answer" == "2" ]]; then
  if [[ -e /home/via/random-stuff/pribadi/saved_cookie ]]; then
    get_cookie=$(cat /home/via/random-stuff/pribadi/saved_cookie)
    echo -e "${pink}cookie confirmed: ${green}$get_cookie${reset} ${reset}"
    read -p $'\e[1:34mshow your barely shortened link? [y/n]\e[1m ' collection
    if [[ "$collection" == "y" ]]; then
      output=$(curl -sXGET 'https://is.gd/recent.php' --cookie "recent=$get_cookie" | html2text | grep -w "https" | tr -d "<>")
      echo -e "${green}$output${reset}"
    else
      echo -e "${kuning}every your collections is piece of shit.\nbye!${reset}"
      exit 0
    fi
  else
    read -p $'\e[1:34menter the cookie to be saved:\e[1m ' saved_cookie
    touch /home/via/random-stuff/pribadi/saved_cookie
    echo $saved_cookie > /home/via/random-stuff/pribadi/saved_cookie
    get_cookie=$(cat /home/via/random-stuff/pribadi/saved_cookie)
    echo -e "${pink}cookie saved: ${green}$get_cookie${reset}${reset}"
    exit 0
  fi
else
  echo "paipai~"
  exit 0
fi
