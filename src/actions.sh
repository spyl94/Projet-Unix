#!/bin/bash

#D�place le personnage dans la pi�ce re�ue en param�tre
function move {
	if [ "${pieces[$1]}" ]; then cd "${perso[5]}/${pieces[$1]}"; clear; 
	else clear; echo "Cette pi�ce n'�xiste pas";
	fi
}
#Utilise le passage secret si il est disponible
function secret {
	echo `ls -F`
}
#Retourne dans la pi�ce pr�c�dente
function reculer {
	if ["$lieu" != "entree" ]; then cd ..; clear;
	else clear; echo "Vous ne pouvez pas reculer...";
	fi
}

function potion {
	echo lol;
}
