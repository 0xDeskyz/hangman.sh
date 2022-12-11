#!/bin/sh

#Player 1 is asked for a word
read -p "Entrez un mot à déviner (EN MINUSCULE) : " random_word

#FONCTIONS
  
hidden_word=$random_word
letter_list=azertyuiopqsdfghjklmwxcvbn #We initialize a list to search for the values found


# Displays the word by replacing the letters not found by _
display_word () {
  echo $1 | tr $2 '_'
}


#Remove a found character from the list of characters not found
discover () {
  letter_list=$(echo $letter_list | tr -d $1)
}


# Test if the word contains hidden characters
test_won (){
  test=$(display_word $1 $2 | sed 's/[^_]*//g')
  if [ -z "$test" ] ##ERROR
   then
     #The hidden word no longer contains a hidden character
    echo 0
   else
     #The hidden word still contains hidden characters
    echo 1
  fi
}


presence_test () {
	if [ $1 = "$(echo $1 | grep $2)" ]
	  then
	    echo 0
	  else
	    echo 1
	fi
}



#MAIN SCRIPT


#Replace accents in words
hidden_word=$(echo $hidden_word | sed 'y/áàâäçéèêëîïìôöóùúüñÂÀÄÇÉÈÊËÎÏÔÖÙÜÑ/aaaaceeeeiiiooouuunAAACEEEEIIOOUUN/')

#Initialization of counters
loop=0
faults=0
faults_max=8

#Main Loop
while [ $(test_won $hidden_word $letter_list) = 1 ]
do
	clear
	remaining_trials=$(expr $faults_max - $faults)
	echo "###################"
	echo "     Tour n°$loop :"
	echo "###################"
	echo "Il vous reste $remaining_trials essais!"
	echo "Mot :"
	display_word $hidden_word $letter_list
	echo
	echo "Lettre à découvrir :"
	read letter
	letter=$(echo $letter | cut -c1)
	
	if [ $(presence_test $hidden_word $letter) = 1 ]
	  then
	    faults=$(expr $faults + 1)
	  else
	    discover $letter
	fi
	
	loop=$(expr $loop + 1)
	
	if [ $faults = 8 ] #We check if the maximum number of faults is reached
	  then
	
		echo "############################"
		echo "     Vous avez perdu !"
		echo "############################"
		echo "Le mot était : $hidden_word"
		exit
	
	  else
	  	echo	  
	fi	
	
done
clear


echo "############################"
echo "     Vous avez gagné !"
echo "############################"
echo "Le mot était : $hidden_word"
echo "Vous avez fait $faults faute(s)"
