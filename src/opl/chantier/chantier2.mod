/***********************************************
* Ordonnancement de tâches pour un chantier de construction  
*
* Question 2
* NB :  il ya plusieurs façons différentes de  répondre à la question
Démarche: Nous avons ajouté une tâche <"ATT", "Attente", 10, {"H"}> qui correspond à une attente de durée 10
entre la fin de la tâche H et le début de la tâche I.
En résumé la tâche ATT commence après la tâche H et la tâche I commence après la tâche ATT.
Ainsi on s'assure qu'il y aura 10 jours d'attente entre les tâches H et I.
************************************************/
using CP;


// tuple de Tache

tuple Tache {
  string code;
  string nom;
  int duree;
  {string} precedences;

}

// Ensemble des données

  {Tache}   TachesChantier = ...;


/********************* Prétraitement **********************/
// trouvons la durée maximale des taches
int maxDuree = max(t in TachesChantier) t.duree;

//trouvons la somme des durées de toutes les taches
int SumDuree = sum(t in TachesChantier) t.duree;

// ensemble code des Taches
{string} code = {t.code | t in TachesChantier};

//Recupérer une tache à partir du code
Tache tachesTable[code] = [t.code : t | t in TachesChantier];

//TODO - Extraction des informations utiles à partir des données brutes
//       au fur et à mesur de vos besoin
//		 dépend de la façon dont vous construisez votre modèle ci-dessous)


/************************ Modèle **************************/

// TODO - Variables de décisions et domaines
range r = 0..SumDuree; // range utilisé pour l'affichage graphique
dvar int dureeTotale in maxDuree..SumDuree; // durée totale du projet
dvar int debut[TachesChantier] in 0..SumDuree; // debut de tache
dvar int fin[TachesChantier] in 0..SumDuree; // fin de ta

// TODO - Objectif et Contraintes

//fonction objectif: minimiser la durée totale des taches
minimize 
  	dureeTotale;

//contraintes à satisfaire
subject to {
	forall(t in TachesChantier) {

		// chaque taches débutent après la fin de ses taches précédentes
		debut[t] >= max(k in t.precedences) fin[tachesTable[k]];

		// la fin de chaque tache correspond à son debut additionné à sa durée
		fin[t] == debut[t] + t.duree;
	}

	// durée totale correspond à la date de fin de la dernière tache (le max des fin de taches)
	dureeTotale == max(t in TachesChantier) fin[t];
}


/******************** Post-traitement **********************/

// TODO - Affichage de la solution

// Afficher pour chaque tâche toutes les informations pertinentes
execute {
    writeln("Executions des taches :\n");
    for (var t in TachesChantier) {

		writeln("Tache ", t.code);
		write("debut: ", debut[t], " fin: ", fin[t], ": ");

        for (var i in r) {
			if(i<debut[t]){
				write("..");
			}
			if (i==debut[t]){
				write("|__");
			}
			if (i>debut[t] && i<fin[t]){
				write("__");
			}
          	
        }

        write("|\n");
    }
}
