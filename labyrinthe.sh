#!/bin/bash
# Projet: Unix
# Authors: Spyl & Alexian: Damos l@bs.
# Github: https://github.com/spyl94/Projet-Unix
echo A Maze Ing by Damos l@bs
DEF_PATH=`pwd`

source src/core.sh

function menu {
while  read -p "Menu:
	1) Nouvelle partie
	2) Charger une partie
	3) Sauvegarder la partie en cours
	4) Voir la feuille de personnage
	q) Quitter
	" choice ; do
        case "$choice" in
                q|Q) exit;;
                1) newchar;;
		2) load;;
		3) save;;
		4) perso;;
                *) echo "Choix non valide..."
        esac
done
}

menu

