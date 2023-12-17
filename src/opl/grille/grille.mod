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

/* Déclarations domaines et variables */

range d = 1..8; // domaine des variables

dvar int Sommet[d] in d; // valeurs des sommets




/* Contraintes */
constraints {
    // Contrainte pour s'assurer que les sommets ont toutes une valeurs différentes
    forall(i in d, j in d: i!=j)
        Sommet[i] != Sommet[j];

    // Les valeurs des voisins d'un sommet S ne sont pas consécutives à celle de S
    //contrainte de différence entre 2 sommets reliés directement par un arc
    abs(Sommet[1] - Sommet[2]) != 1;
    abs(Sommet[1] - Sommet[3]) != 1;
    abs(Sommet[1] - Sommet[4]) != 1;

    abs(Sommet[2] - Sommet[5]) != 1;
    abs(Sommet[2] - Sommet[3]) != 1;
    abs(Sommet[2] - Sommet[6]) != 1;

    abs(Sommet[3] - Sommet[4]) != 1;
    abs(Sommet[3] - Sommet[5]) != 1;
    abs(Sommet[3] - Sommet[6]) != 1;
    abs(Sommet[3] - Sommet[7]) != 1;

    abs(Sommet[4] - Sommet[6]) != 1;
    abs(Sommet[4] - Sommet[7]) != 1;

    abs(Sommet[5] - Sommet[6]) != 1;
    abs(Sommet[5] - Sommet[8]) != 1;

    abs(Sommet[6] - Sommet[7]) != 1;
    abs(Sommet[6] - Sommet[8]) != 1;

    abs(Sommet[7] - Sommet[8]) != 1;
    // abs calcul la valeur absolue

}


/* Post-traitement (Affichage Solution) */

execute {
    writeln("Solution du modele grille:");

    for (var i in d)
    {
        writeln("Sommet[", i, "] =", Sommet[i]);
    }
}