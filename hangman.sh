#!/bin/sh

###################
#### FONCTIONS ####
###################

#On demande un mot au Joueur 1
read -p "Entrez un mot à déviner (EN MINUSCULE) : " motAuHasard
  
motCache=$motAuHasard
listeLettresCachees=azertyuiopqsdfghjklmwxcvbn #On initialise un liste pour rechercher les valeurs trouvés


# Affiche le mot en remplacant les lettre non trouvées par des _
afficheMot () {
  echo $1 | tr $2 '_'
}


# Supprimer un caractère trouvé de la liste des caractères non trouvés
decouvre () {
  listeLettresCachees=$(echo $listeLettresCachees | tr -d $1)
}


# Test si le mot contient des caractères cachés
testGagne (){
  test=$(afficheMot $1 $2 | sed 's/[^_]*//g')
  if [ -z "$test" ] ##ERREUR
   then
     # Le mot caché ne contient plus de caractère caché
    echo 0
   else
     # Le mot caché contient encore des caractères cachés
    echo 1
  fi
}


testPresence () {
	if [ $1 = "$(echo $1 | grep $2)" ]
	  then
	    echo 0
	  else
	    echo 1
	fi
}



###################
####   SCRIPT  ####
###################


#Remplace les accents dans les mots
motCache=$(echo $motCache | sed 'y/áàâäçéèêëîïìôöóùúüñÂÀÄÇÉÈÊËÎÏÔÖÙÜÑ/aaaaceeeeiiiooouuunAAACEEEEIIOOUUN/')

#Initialisation des compteurs
tour=0
fautes=0
fautes_max=8

#Boucle principale
while [ $(testGagne $motCache $listeLettresCachees) = 1 ]
do
	clear
	essais_restants=$(expr $fautes_max - $fautes)
	echo "###################"
	echo "     Tour n°$tour :"
	echo "###################"
	echo "Il vous reste $essais_restants essais!"
	echo "Mot :"
	afficheMot $motCache $listeLettresCachees
	echo
	echo "Lettre à découvrir :"
	read lettre
	lettre=$(echo $lettre | cut -c1)
	
	if [ $(testPresence $motCache $lettre) = 1 ]
	  then
	    fautes=$(expr $fautes + 1)
	  else
	    decouvre $lettre
	fi
	
	tour=$(expr $tour + 1)
	
	if [ $fautes = 8 ] #On verifie si le nombre de fautes maximum est atteint
	  then
	
		echo "############################"
		echo "     Vous avez perdu !"
		echo "############################"
		echo "Le mot était : $motCache"
		exit
	
	  else
	  	echo	  
	fi	
	
done
clear


echo "############################"
echo "     Vous avez gagné !"
echo "############################"
echo "Le mot était : $motCache"
echo "Vous avez fait $fautes faute(s)"
