/*********************************************
 * Modèle OPL Pour le problème des Carrés latin
 *
 * Dans ce modèle, chaque variable doit être déclarée explicitement
 * en gardant son nom d'origine dans votre formalisation
 *
 *********************************************/
 
using CP; /* Utilisation du solveur CP-Solver */


/* Paramétrage du solveur */   /* Ne pas oublier */
execute {
    cp.param.searchType = "DepthFirst" ;
    cp.param.workers = 1;
}

/* Données du problème*/

int n=15; // la taille de la matrice


/* Déclarations domaines et variables */

range d = 1..n; // domaine des variables

dvar int carreLatin[d][d] in d; // valeurs des cellules




/* Contraintes */
constraints {
    // Contrainte pour s'assurer qu'une valeur apparaît une fois dans chaque ligne
    forall(i in d)
        forall(j,k in d : j<k)
            carreLatin[i][j] != carreLatin[i][k];

    // Contrainte pour s'assurer qu'une valeur apparaît une fois dans chaque colonne
    forall(j in d)
        forall(i,k in d : i<k)
            carreLatin[i][j] != carreLatin[k][j];
}


/* Post-traitement (Affichage Solution) */

execute {
    writeln("Solution du modele :");

    for (var i in d)
    {
        for (var j in d)
        {
            writeln("carreLatin[", i, "][", j, "] =", carreLatin[i][j]);
        }
    }
}