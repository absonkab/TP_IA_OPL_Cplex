/*********************************************
 * Modèle OPL Pour le problème des n-reines
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
    cp.param.logVerbosity = "Quiet";
    cp.param.timeMode = "ElapsedTime";
}

// /* Données du problème*/

int n = ...; // taille de l'échiquier


// /* Déclarations domaines et variables */

range colonne = 1..n;

dvar int Reine[colonne] in colonne; // reine de l'indice colonne

//affectation des variable par ordre d'indice croissant et par valeurs croissantes
execute {
    var f =cp.factory;
    cp.setSearchPhases(
        f.searchPhase(
            Reine,
            f.selectSmallest(
                f.varIndex(Reine) // indices croissant
            ), 
            f.selectSmallest(f.value())          // valeurs croissantes
        )
    );
}

// Contraintes
constraints {

    // deux reines ne peuvent pas être sur la même colonne
    forall(i, j in colonne: i<j) {
        Reine[i] != Reine[j];

    }

    // deux reines ne peuvent pas être sur la même diagonale
    forall(i, j in colonne: i<j) {
        abs(Reine[j]-Reine[i]) != abs(j-i);
    }
}

//Affichage des solutions
execute {
    writeln("Solutions au problème des ", n, "-Reines :");
    for(var x in colonne){
        writeln("A la ligne "+ x + " la reine se trouve a la colonne "+Reine[x]+"\n")
    }
}

// Affichage en graphique
execute {
    writeln("Disposition des reines sur l'échiquier :");
    for (var r in colonne) {
        for (var c in colonne) {
            write(Reine[r] == c ? " Q " : " . ");
        }
        writeln();
    }
}

execute {
    write("\nNombre d'echecs: ",cp.info.numberOfFails);
    write("\nNombre de points de choix: ",cp.info.numberOfChoicePoints);
    write("\nLe temps ecoule: ",cp.info.solveTime);
}
