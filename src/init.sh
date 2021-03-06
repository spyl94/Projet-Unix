#Place les objets dans les salles
function initObjects {
	touch $1/armes.txt $1/enigmes.txt $1/mobs.txt $1/potions.txt $1/enigmes.txt $1/description.txt #inutile mais demand� par l'�nonc�.
	if [ $(($RANDOM%2)) -eq 0 ]; then
		echo $(sed -n $((1 + ($RANDOM % $(cat $DEF_PATH"/lib/armes.txt" | wc -l))))"p" $DEF_PATH"/lib/armes.txt") >> $1/armes.txt;
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then
 		echo $(sed -n $((1 + ($RANDOM % $(cat $DEF_PATH"/lib/mobs.txt" | wc -l))))"p" $DEF_PATH"/lib/mobs.txt") >> $1/mobs.txt;
		((nombreMobs++))
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then
		echo $(sed -n $((1 + ($RANDOM % $(cat $DEF_PATH"/lib/potions.txt" | wc -l))))"p" $DEF_PATH"/lib/potions.txt") >> $1/potions.txt;
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then
		echo $(sed -n $((1 + ($RANDOM % $(cat $DEF_PATH"/lib/enigmes.txt" | wc -l))))"p" $DEF_PATH"/lib/enigmes.txt") >> $1/enigmes.txt;
		((nombreEnigmes++))
	fi
	echo $(sed -n $((1 + ($RANDOM % $(cat $DEF_PATH"/lib/description.txt" | wc -l))))"p" $DEF_PATH"/lib/description.txt") > $1/description.txt;
}

#Cr�e la carte du jeu
function initPlacement {
	find "$DEF_PATH/entree" -type d | (while read A ; do initObjects $A; done
	if [[ "$nombreMobs" -gt 12 && "$nombreEnigmes" -gt 8 ]]; then echo "G�n�ration de la carte termin�e."; else initPlacement; fi
	)
}

#Initialise la carte
function initMap {
	rm -Rf $DEF_PATH/entree
	mkdir -p $DEF_PATH/entree/{hall/{chambre/{armoire,bibliotheque},cuisine/{coin,garde_manger/abattoir},salon/{cheminee,etage},escalier/{cave,crypte}},jardin/{cabane,allee/foret/{grotte,champignonniere}}}
	if [ $? != 0 ]; then echo "Impossible de cr�er la carte."; exit; fi

	#sortie:
	rand=$((3 + ($RANDOM % 15 )));
	find "$DEF_PATH/entree" -type d | while read A ; do 
	let "cpt+=1"; if [ $rand -eq $cpt ]; then mkdir $A/sortie; fi
	done

	#passage secret:
	rand=$((3 + ($RANDOM % 15 )));
	rand2=$((3 + ($RANDOM % 15 )));
	cpt=0
	cpt2=0
	find "$DEF_PATH/entree" -type d | while read A ; do 
	let "cpt+=1"; if [ $rand -eq $cpt ]; then 
		find "$DEF_PATH/entree" -type d | while read B ; do 
		let "cpt2+=1"; if [ $rand2 -eq $cpt2 ]; then 
			ln -s $B $A; #echo "Passage entre $B et $A";
		fi; done
	fi; done

	nombreMobs=0;
	nombreEnigmes=0;
	initPlacement
}

#Initialise la partie
function start {
	initMap
	cd entree
	pwd >> "$DEF_PATH"/char.txt
	clear
	game
}
