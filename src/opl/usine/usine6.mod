/***********************************************
 * Modèle pour le problème de l'usine 
 * Version avec des variables de décision de type intervalle
 * 
 * Avec prise en compte de la consommation électrique
 * Avec prise en compte de la panne et son impact 
 *  sur les tâches F, G, H, K
 * Avec démarrage de la tâche P au plus tard
 ***********************************************/
/* Binome : TODO                               */

// Nous allons utiliser un autre fichier instance nommer instance2.dat où inclure les tâches F, G, H, K

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

// ensemble des taches qui ne se chevauchent pas
{string} taches_disjointes = ...;

range r = 0..SumDuree; // range utilisé pour l'affichage graphique


//----------------------- Modèle ---------------------------

// -- variables de décisions --
dvar interval t[tch in taches] in 0..SumDuree size tch.duree; //
dvar int debut[taches] in 0..SumDuree; // debut de tache
dvar int fin[taches] in 0..SumDuree; // fin de tache

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

    // Contraintes de ressources d'électricité
    consommation <= puissanceMax;

    //contrainte sur les taches disjointes dans leur execution
    noOverlap(all (code in taches_disjointes) t[tachesTable[code]]);

    // la tache P doit commencer au plus tard
    // donc le debut de la tache P doit etre superieur a la fin de la derniere des taches excepté P 
    startOf(t[tachesTable["P"]]) >= max(tch in taches : tch.code != "P") endOf(t[tachesTable[tch.code]]);
    
}	


//----------------------- Affichage Solution ---------------------------

int capacite_instant[i in r] = cumulFunctionValue(consommation,i); // capacité pour chaque instant
range instants = 0..dureeTotale;

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

    // affichage de la capacité à chaque instant
    writeln("Consommation electricite à chaque instant du planning :\n");
    for (var i in instants) {
        write("Instant ", i, " : ");
        write(capacite_instant[i], " kW |");
    }
}