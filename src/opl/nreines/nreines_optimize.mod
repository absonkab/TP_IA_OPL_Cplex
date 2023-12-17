/*********************************************
 * Modèle OPL pour l'optimisation sous contrainte
 * Placement minimal de reines sur un échiquier
 * de taille n*n pour contrôler toutes les cases
 *********************************************/

using CP; /* Utilisation du solveur CP-Solver */

/* Paramétrage du solveur */
execute {
    cp.param.searchType = "DepthFirst";
    cp.param.workers = 1;
}

// Données du problème
int n = ...; // Taille de l'échiquier

// Déclarations domaines et variables
range rows = 1..n;
range cols = 1..n;
range controlTimes = 1..3*n;

// Variable de décision : si une case (i, j) est controlée par une reine
dvar boolean Reine[rows,cols];

// Objectif : minimiser le nombre total de reines placées
minimize 
    sum(i in rows, j in cols) Reine[i,j];

// Contraintes
subject to {

    forall(i in rows, j in cols) 
        (sum(k in rows) Reine[k][j] >= 1) ||
        (sum(l in cols) Reine[i][l] >= 1) ||
        (sum(k in i..n, l in j..n) Reine[k+1][l+1] >= 1) ||
        (sum(k in rows: k + i <= n) Reine[k][k+i] >= 1) ||
        (sum(k in rows: k + j <= n) Reine[k+1][k] >= 1) ||
        (sum(k in rows: k - i >= 1) Reine[k][k-1] >= 1) ||
        (sum(k in rows: k - j >= 1) Reine[k-1][k] >= 1);

}


// Affichage des solutions
execute {
    writeln("Disposition des reines sur l'échiquier :");
    for (var i in rows) {
        for (var j in cols) {
            write(Reine[i][j] ? " Q " : " . ");
        }
        writeln();
    }
}