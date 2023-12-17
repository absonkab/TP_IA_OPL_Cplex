
/**************************************************************
 * Modèle pour le problème du sudoku nxn
 * (à inclure dans  un modèle contenant le l'entête "using CP;" + paramétrage du solveur
 **************************************************************/

// --- Données ---
int n = ...	;						// square order
range rsud = 1..n;
int instance[rsud][rsud] = ...;


// --- Pretraitement ---
int sous_grille = ftoi(sqrt(n)); // taille des sous grilles
range taille_grille = 1..sous_grille;
range parcours_grille = 0..n-1; // range pour iterer dans une sous grille

// --- Modèle ---
dvar int sudoku[rsud][rsud] in rsud; // valeurs des cellules
dvar int grid[taille_grille][taille_grille] in rsud; // valeurs des sous grilles

/* Contraintes */
constraints {
    // sudoku contient les valeurs de l'instance
    forall(i,j in rsud){
        if(instance[i][j] != 0) {
            sudoku[i][j] == instance[i][j];
        }
    }

    // Contrainte pour s'assurer qu'une valeur apparaît une fois dans chaque ligne
    forall(i in rsud)
        allDifferent(all ( j in rsud) sudoku[i][j]);

    // Contrainte pour s'assurer qu'une valeur apparaît une fois dans chaque colonne
    forall(j in rsud)
        allDifferent(all ( i in rsud) sudoku[i][j]);

    // Contrainte pour s'assurer qu'une valeur apparaît une fois dans chaque sous grille
    forall(i in parcours_grille: i%sous_grille==0) {
        forall(j in parcours_grille: j%sous_grille==0) {
            allDifferent(all (x,y in taille_grille) sudoku[i+x][j+y]);
        }
    }

}


// --- PostTraitement --- (affichage solution)

execute {
    writeln("Solution du sudoku :");

    for (var i in rsud)
    {
        for(var j in rsud){
            write("----");
        }
        writeln("");

        write("|");

        for (var j in rsud)
        {
        
            write(" " + sudoku[i][j] + " |");
        }
        writeln("");
    }
    for(var j in rsud){
        write("----");
    }
    writeln("\n")
}
