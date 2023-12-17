/***********************************************
 * Modèle pour le problème de l'usine 
 * Version avec des variables de décision de type intervalle
 * 
 * Avec prise en compte de la consommation électrique
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

// -- variables de commodité --
cumulFunction consommation = sum(tch in taches) pulse(t[tch], tch.puissance); // expression de type fonction représentant la consommation d'électricité à chaque instant

// -- Critère d'optimisation --
dvar int dureeTotale in maxDuree..SumDuree; // durée totale du projet


minimize 
   // Objectif
   dureeTotale;

subject to {
    // Contraintes

    // la fin de chaque tache correspond à son debut additionné à sa durée
    // contrainte déjà assurée dans la déclaration de l'intervalle

	// chaque tache débute après la fin de ses taches précédentes
	forall(c in cords)
		endBeforeStart(t[tachesTable[c.avant]], t[tachesTable[c.apres]]);

	// durée totale correspond à la date de fin de la dernière tache (le max des fin de taches)
	dureeTotale == max(tch in taches) endOf(t[tch]);

    // Contraintes de ressources d'électricité
    consommation <= puissanceMax;
    
}	


//----------------------- Affichage Solution ---------------------------

int capacite_instant[i in r] = cumulFunctionValue(consommation,i); // capacité pour chaque instant
range instants = 0..dureeTotale;

execute {
    
    writeln("Ordre d'execution des taches :\n");
    for (var tch in taches) {

		writeln("Tache ", tch.code);
		write("debut: ", t[tch].start, " fin: ", t[tch].end, ": ");

        for (var i in r) {
			if(i<t[tch].start){
				write("..");
			}
			if (i==t[tch].start){
				write("D__");
			}
			if (i>t[tch].start && i<t[tch].end){
				write("__");
			}
          	
        }

        writeln("F\n");
        
    }

    // affichage de la capacité à chaque instant
    writeln("Consommation electricite à chaque instant du planning :\n");
    for (var i in instants) {
        write("Instant ", i, " : ");
        write(capacite_instant[i], " kW |\n");
    }
}