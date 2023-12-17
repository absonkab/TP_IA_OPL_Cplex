/*********************************************
 * Modèle OPL Pour le problème des Carrés Magique
 *********************************************/
 
using CP; /* Utilisation du solveur CP-Solver */


/* Paramétrage du solveur */   /* Ne pas oublier */
execute {
    cp.param.searchType = "DepthFirst" ;
    cp.param.workers = 1;
}

/* Données du problème*/
int n = ...;

/* Pré-traitement*/
int sm = n * (n * n + 1) div 2;


/* Déclarations domaines et variables */

range rows = 1..n;

int min_nb = 1;
int max_nb = n*n;

dvar int Cm[rows, rows] in min_nb..max_nb;

constraints{

    // Contrainte : Chaque nombre est utilisé une fois
    forall (i in rows, j in rows)
        forall(k in rows, l in rows: i!=k || j!=l)
            Cm[i,j] != Cm[k,l];

    // Contrainte : Somme magique pour les lignes
    forall (i in rows)
        sum (j in rows) Cm[i, j] == sm;

    // Contrainte : Somme magique pour les colonnes
    forall (j in rows)
        sum (i in rows) Cm[i, j] == sm;

    // Contrainte : Somme magique pour la diagonale montante
    sum (i in rows) Cm[i, i] == sm;

    // Contrainte : Somme magique pour la diagonale descendante
    sum (i in rows) Cm[i, n - i + 1] == sm;
}


// Affichage de la solution
execute {
    writeln("Carré magique :");
    for (var i in rows) {
        for (var j in rows)
            write(Cm[i][j], "\t");
        writeln();
    }
    writeln("somme magique: ",sm);
}
