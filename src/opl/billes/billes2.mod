/*********************************************
* Modèle OPL Pour le problème des billes
*
* Dans ce modèle, on veut regrouper les variables dans
* une ou plusieurs structures
*
*********************************************/

using CP; // Utilisation du solveur CP-Solver

// Déclaration des domaines et des variables
range ages = 4..7;
range noms = 1..4; // 1= Anne, 2= Bernard, 3= Claudine, 4= Denis
range colors = 1..4; // 1= Bleue, 2= Jaune, 3= Noire, 4= Rouge
range locations = 1..4; // 1= Parc, 2= Jardin, 3= Chambre, 4= Salon

// dvar int Anne in ages;
// dvar int Bernard in ages;
// dvar int Claudine in ages;
// dvar int Denis in ages;
dvar int Enfants[noms] in ages;
dvar int Billes[colors] in ages; // Tableau pour les billes
dvar int JoueDans[locations] in ages; // Tableau pour les endroits de jeu

/* Paramétrage du solveur */
execute {
    cp.param.searchType = "DepthFirst";
    cp.param.workers = 1;
}

/* Contraintes */
constraints {
    
    // Tous les enfants ont des prénoms différents
    forall(i in noms, j in noms: i!=j)
        Enfants[i] != Enfants[j];
    
    // Tous les enfants jouent à des endroits différents
    forall(i in locations, j in locations: i!=j)
        JoueDans[i] != JoueDans[j];

    // Tous les enfants ont des billes différentes
    forall(i in colors, j in colors: i!=j)
        Billes[i] != Billes[j];

    
    // Contraintes spécifiques
    // contrainte 1: 
   // Denis joue dans le parc 
    Enfants[4] == JoueDans[1];

    // et n'a pas 4 ans
    Enfants[4] != 4;

    // contrairement à l’enfant qui a des billes bleues: 
    Billes[1] == 4; 

    // contrainte 2. La fille de 6 ans a des billes jaunes:
    Billes[2] == 6; 
    (Enfants[1] == 6 && Billes[2] == 6) || (Enfants[3] == 6 && Billes[2] == 6); // Anne ou Claudine a des billes jaunes

    Billes[3] > JoueDans[2]; // L'enfant qui joue avec des billes noires est plus âgé que l'enfant qui joue dans le jardin
    Billes[3] < Enfants[1]; // Mais plus jeune que Anne

    Enfants[1] == JoueDans[3]; // Anne joue dans sa chambre
    Enfants[1] == JoueDans[4] + 1; // Anne a 1 an de plus que l'enfant qui joue dans le salon
}

/* Post-traitement (Affichage Solution) */
execute {
    writeln("Age de Anne est ", Enfants[1]);
    writeln("Age de Bernard est ", Enfants[2]);
    writeln("Age de Claudine est ", Enfants[3]);
    writeln("Age de Denis est ", Enfants[4]);

    writeln("Age de celui qui joue dans le parc est ", JoueDans[1]);
    writeln("Age de celui qui joue dans le jardin est ", JoueDans[2]);
    writeln("Age de celui qui joue dans la chambre est ", JoueDans[3]);
    writeln("Age de celui qui joue dans le salon est ", JoueDans[4]);

    for (var c in colors) {
        writeln("Age de celui qui a les billes ", c, " est ", Billes[c]);
    }
}