function game {
	echo -en "\e[1;34m$1\e[0m"
	nb=0 
	declare -a perso pieces mobs potions enigmes armes

	#On r�cup�re les infos du fichier char.txt
	while read ligne ; do perso[$nb]=$ligne; let "nb+=1";
	done < "$DEF_PATH"/char.txt
	lieu=$(basename "${perso[5]}");
	if [ $lieu = sortie ]; then win; fi
	declare -i pvMax="${perso[2]}"
	declare -i pv="${perso[3]}"
	arme="${perso[4]}"
	nomArme=$(cut -d : -f 1 $DEF_PATH"/char.txt" | sed -n '5p')
	degArme=$(cut -d : -f 3 $DEF_PATH"/char.txt" | sed -n '5p')
	nb=0
	echo -e "------------------\n|${perso[0]}\n|PV: \e[1;32m$pv/$pvMax\e[0m\n|Arme:  \e[0;34m$nomArme\e[0m\n------------------\n|Lieu:  \e[0;34m$lieu\e[0m"
	
	mobsCount=0 #On r�cup�re les monstres
	if [ -f "${perso[5]}"/mobs.txt ]; then 
		while read ligne ; do mobs[$mobsCount]=$ligne; let "mobsCount+=1";
		done < "${perso[5]}"/mobs.txt; fi
	potionsCount=0	#On r�cup�re les potions disponibles
	if [ -f "${perso[5]}"/potions.txt ]; then 
		while read ligne ; do potions[$potionsCount]=$ligne; let "potionsCount+=1";
		done < "${perso[5]}"/potions.txt; fi
	enigmesCount=0	#On r�cup�re les �nigmes disponibles
	if [ -f "${perso[5]}"/enigmes.txt ]; then 
		while read ligne ; do enigmes[$enigmesCount]=$ligne; let "enigmesCount+=1";
		done < "${perso[5]}"/enigmes.txt; fi
	armesCount=0	#On r�cup�re les armes disponibles
	if [ -f "${perso[5]}"/armes.txt ]; then 
		while read ligne ; do armes[$armesCount]=$ligne; let "armesCount+=1";
		done < "${perso[5]}"/armes.txt; fi
	nb=0	#On r�cup�re les pi�ces disponibles
	for i in $(ls -F | grep / 2>/dev/null); do pieces[$nb]=$i; let "nb+=1"; done

	echo -e "|Arme(s): \e[1;33m   $armesCount\e[0m\n|Monstre(s): \e[1;33m$mobsCount\e[0m\n|Potion(s): \e[1;33m $potionsCount\e[0m\n|Enigme(s): \e[1;33m $enigmesCount\e[0m\n------------------";
	cat description.txt
	echo "Actions:"; nb=0;
	if [ ! $mobsCount -eq 0 ]; then for i in "${mobs[@]}"; do echo $nb") Attaquer : $i" | cut -d: -f1,2; let "nb+=1"; done
	elif [ ! $enigmesCount -eq 0 ]; then for i in "${enigmes[@]}"; do echo $nb") R�soudre l'�nigme : $i" | cut -d: -f1,2; let "nb+=1"; done
	else for i in "${pieces[@]}"; do echo $nb") Aller : $i"; let "nb+=1"; done; fi
	if [ ! $armesCount -eq 0 ]; then echo "A) Changer d'Arme"; fi
	echo "C) Chercher un Passage Secret"
	echo "M) Menu Principal"
	[ ! $potionsCount -eq 0 ] && echo "P) Utiliser Potion";
	echo "Q) Quitter"
	if [ "$lieu" != "entree" ]; then echo "R) Reculer d'une pi�ce"; fi

	read choice 
        case "$choice" in
		a|A) armes;;
                q|Q) exit;;
		c|C) secret;;
                m|M) menu;;
		p|P) potion;;
		r|R) reculer;;
		0|1|2|3|4|5) choice $choice;;
                *) echo "Choix non valide..."
        esac
	#On enregistre la configuration du joueur:
	char "${perso[0]}" "${perso[1]}" "${perso[2]}" "$pv" "$arme" `pwd`
	game #On relance
}
