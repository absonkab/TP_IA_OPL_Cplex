/***********************************************
 * Modèle pour le problème de l'usine 
 * Version avec des variables de décision de type intervalle
 * 
 * Sans tenir compte de la consommation électrique
 ***********************************************/
/* Binome : TODO                               */

using CP;

// ----- Structures de données pour décrire une instance de problème -----
include "structures.mod";

//----------------------- Données ---------------------------
{Tache} taches = ...;        // les taches du probleme
{Ord}    cords = ...;       // les contraintes d'ordonnancement entre taches
int	  puissanceMax = ...;   // la puissance maximale de l'usine

//----------------------- Pretraitement ---------------------------
	    
// trouvons la durée maximale des taches
int maxDuree = max(t in taches) t.duree;

//trouvons la somme des durées de toutes les taches
int SumDuree = sum(t in taches) t.duree;

// ensemble code des Taches
{string} codes = {t.code | t in taches};

//Recupérer une tache à partir du code
Tache tachesTable[codes] = [t.code : t | t in taches];

range r = 0..SumDuree; // range utilisé pour l'affichage graphique

//----------------------- Modèle ---------------------------

// -- variables de décisions --
dvar interval t[tch in taches] in 0..SumDuree size tch.duree; //
dvar int debut[taches] in 0..SumDuree; // debut de tache
dvar int fin[taches] in 0..SumDuree; // fin de tache

// -- variables de commodité --

// -- Critère d'optimisation --
dvar int dureeTotale in maxDuree..SumDuree; // durée totale du projet



minimize 
   // Objectif
   dureeTotale;

subject to {
    // Contraintes

	// la fin de chaque tache correspond à son debut additionné à sa durée
    // contrainte déjà assurée dans la déclaration de l'intervalle

    // recupération des valeurs de debut et fin pour l'affichage
    forall(tch in taches) {
        debut[tch] == startOf(t[tch]); // debut de tache
        fin[tch] == endOf(t[tch]); // fin de tache
    }

	// chaque tache débute après la fin de ses taches précédentes
	forall(c in cords)
		endBeforeStart(t[tachesTable[c.avant]], t[tachesTable[c.apres]]);

	// durée totale correspond à la date de fin de la dernière tache (le max des fin de taches)
	dureeTotale == max(tch in taches) endOf(t[tch]);
    
}	


//----------------------- Affichage Solution ---------------------------


execute {
    
    
    writeln("Ordre d'execution des taches :\n");
    for (var t in taches) {

		writeln("Tache ", t.code);
		write("debut: ", debut[t], " fin: ", fin[t], ": ");

        for (var i in r) {
			if(i<debut[t]){
				write("..");
			}
			if (i==debut[t]){
				write("D__");
			}
			if (i>debut[t] && i<fin[t]){
				write("__");
			}
          	
        }

        writeln("F\n");
    }
}