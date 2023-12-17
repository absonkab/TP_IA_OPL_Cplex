/***********************************************
 * Modèle pour le problème de l'usine 
 * Version avec des variables de décision de type entière
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
dvar int debut[taches] in 0..SumDuree; // debut de tache
dvar int fin[taches] in 0..SumDuree; // fin de tache

// -- variables de commodité --
dvar boolean tachesEnCours[taches][r] in 0..1; //variable binaire qui vaut 1 si la tâche t est en cours à l’instant d, et 0 sinon.

// -- Critère d'optimisation --
dvar int dureeTotale in maxDuree..SumDuree; // durée totale du projet


minimize 
   // Objectif
   dureeTotale;

subject to {
    // Contraintes

	// la fin de chaque tache correspond à son debut additionné à sa durée
    forall(t in taches)
		fin[t] == debut[t] + t.duree;

	// chaque tache débute après la fin de ses taches précédentes
	forall(c in cords)
		debut[tachesTable[c.apres]] >= fin[tachesTable[c.avant]];

    // forall(instant in 0..SumDuree)
    //     (sum(tache in taches : debut[tache] <= instant && instant < fin[tache]) tache.puissance) <= puissanceMax;

    // représenter si une tâche est en cours à un moment donné
    // forall(t in taches, d in r){
    //     tachesEnCours[t][d] == (debut[t] <= d) * (d < fin[t]);
    // }

    // Pour chaque point de temps t, la consommation d’énergie totale de toutes les tâches en cours inférieur ou égale à puissanceMax.
    forall(d in r)
        // (sum(t in taches) t.puissance * tachesEnCours[t][d]) <= puissanceMax;
        (sum(t in taches) t.puissance * (debut[t] <= d) * (d < fin[t])) <= puissanceMax;

	// durée totale correspond à la date de fin de la dernière tache (le max des fin de taches)
	dureeTotale == max(t in taches) fin[t];
    
}	


//----------------------- Affichage Solution ---------------------------
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
         capacite_instant = 0 ;
        for(var t in taches){
            if(debut[t] <= i && i < fin[t] ){
                capacite_instant += t.puissance;
            }
        }
        write("Instant ", i, " : ");
        write(capacite_instant, " kW |\n");
    }
    
}