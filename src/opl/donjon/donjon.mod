/*********************************************
 * Modèle OPL Pour le problème des n-reines
 *********************************************/
 
using CP; /* Utilisation du solveur CP-Solver */

/* Paramétrage du solveur */   /* Ne pas oublier */
execute {
    cp.param.searchType = "DepthFirst" ;
    cp.param.workers = 1;
}

/* Données du problème*/




/* Déclarations domaines et variables */
range soldats = 1..12;
range directions = 1..8; // 1=Nord, 2=Est, 3=Sud, 4=Ouest, 5=Nord-Est, 6=Nord-Ouest, 7=Sud-est, 8=Sud-Ouest

// Variable de décision pour représenter la direction dans laquelle chaque soldat regarde
dvar int NombreSoldat[directions] in soldats;
// NombreSoldat[4] = 2 signifie que 2 soldats regarde la direction Ouest

// Contraintes
constraints {

    // sur chaque coté, il y'a au moins 5 pairs d'yeux
    NombreSoldat[1] + NombreSoldat[5] + NombreSoldat[6] >= 5; 
    NombreSoldat[2] + NombreSoldat[5] + NombreSoldat[7] >= 5; 
    NombreSoldat[3] + NombreSoldat[7] + NombreSoldat[8] >= 5; 
    NombreSoldat[4] + NombreSoldat[6] + NombreSoldat[8] >= 5; 

    // la somme des nombre de soldats des differentes directions est 12 
    (sum(c in directions) NombreSoldat[c]) == 12;
}

// Affichage du donjon avec l'emplacement des soldats
execute {
    writeln("Nombre de soldats dans chaque direction :");

    for (var dir in directions) {
        // Affichage du nombre de soldat en fonction de sa direction
        writeln("il y\'a ", NombreSoldat[dir], " soldat ", 
            dir == 1 ? "au Nord" : 
            dir == 2 ? "à l\'Est" : 
            dir == 3 ? "au Sud" : 
            dir == 4 ? "à l\'Ouest" :
            dir == 5 ? "au Nord-Est" : 
            dir == 6 ? "au Nord-Ouest" : 
            dir == 7 ? "au Sud-Est" : "au Sud-Ouest"
        );
    }
    writeln("\n=======================================================================\n");
}

execute {

    writeln("Disposition des soldats dans le donjon :");
    writeln("\n");
    // Affichage du nombre de soldat sur les coins et côtés
    writeln("(",NombreSoldat[6],")"," ================== ","(",NombreSoldat[1],")"," ================== ","(",NombreSoldat[5],")","          ", "(",NombreSoldat[6],")"," ================== ","(",NombreSoldat[1],")"," ================== ","(",NombreSoldat[5],")");
    writeln(" =============================================== ","          ", " ==                                           == ");
    writeln(" =============================================== ","          ", " ==                                           == ");
    writeln(" =============================================== ","          ", " ==                                           == ");
    writeln(" =============================================== ","          ", " ==                                           == ");
    writeln(" =============================================== ","          ", " ==                                           == ");
    // writeln(" =============================================== ");
    // writeln(" =============================================== ");
    // writeln(" =============================================== ");
    // writeln(" =============================================== ");
    writeln("(",NombreSoldat[4],")"," ===============LE DONJON ================ ","(",NombreSoldat[2],")","          ", "(",NombreSoldat[4],")","                LE DONJON                 ","(",NombreSoldat[2],")");
    writeln(" =============================================== ","          ", " ==                                           == ");
    writeln(" =============================================== ","          ", " ==                                           == ");
    writeln(" =============================================== ","          ", " ==                                           == ");
    writeln(" =============================================== ","          ", " ==                                           == ");
    writeln(" =============================================== ","          ", " ==                                           == ");
    // writeln(" =============================================== ");
    // writeln(" =============================================== ");
    // writeln(" =============================================== ");
    // writeln(" =============================================== ");
    // writeln(" =============================================== ");
    writeln("(",NombreSoldat[8],")"," ================== ","(",NombreSoldat[3],")"," ================== ","(",NombreSoldat[7],")","          ","(",NombreSoldat[8],")"," ================== ","(",NombreSoldat[3],")"," ================== ","(",NombreSoldat[7],")");
}


/*int n = 12;
range soldats = 1..n;
range cotes = 1..8; // 1=Nord, 2=Est, 3=Sud, 4=Ouest, 5=Nord-Est, 6=Nord-Ouest, 7=Sud-est, 8=Sud-Ouest


// Variable de décision pour représenter la direction dans laquelle chaque soldat regarde
dvar boolean Regarde[soldats][cotes];
// Regarde[2][4] = 1 signifie que le 2ème soldat regarde la direction Ouest

// Contraintes
constraints {
    // Chaque soldat regarde dans une seule direction
    forall(s in soldats)
        (sum(dir in 1..8) Regarde[s][dir]) == 1;

    // Au moins 5 paires d'yeux scrutent chaque direction
    (sum(s in soldats) Regarde[s][1] + sum(s in soldats) Regarde[s][5] + sum(s in soldats) Regarde[s][6]) >= 5 ; // Ceux qui regardent au Nord
    (sum(s in soldats) Regarde[s][2] + sum(s in soldats) Regarde[s][5] + sum(s in soldats) Regarde[s][7]) >= 5; // Ceux qui regardent à l'Est
    (sum(s in soldats) Regarde[s][3] + sum(s in soldats) Regarde[s][7] + sum(s in soldats) Regarde[s][8]) >= 5; // Ceux qui regardent au Sud
    (sum(s in soldats) Regarde[s][4] + sum(s in soldats) Regarde[s][6] + sum(s in soldats) Regarde[s][8]) >= 5; // Ceux qui regardent à l'Ouest
    
    // Si un soldat regarde dans une direction il peut pas regarder à la direction opposée
    forall (s in soldats)
        (Regarde[s][1] + Regarde[s][7] + Regarde[s][8]) <= 1; // Ceux qui regardent au Nord peuvent pas regarder au sud-est ni sud-ouest
        
    forall (s in soldats)
        (Regarde[s][2] + Regarde[s][6] + Regarde[s][8]) <= 1; // Ceux qui regardent à l'Est peuvent pas regarder au nord-ouest ni sud-ouest
        
    forall (s in soldats)
        (Regarde[s][3] + Regarde[s][5] + Regarde[s][6]) <= 1; // Ceux qui regardent au Sud peuvent pas regarder au nord-est ni nord-ouest
        
    forall (s in soldats)
        (Regarde[s][4] + Regarde[s][5] + Regarde[s][7]) <= 1; // Ceux qui regardent à l'Ouest peuvent pas regarder au nord-est ni sud-est
    

}

// Affichage du donjon avec l'emplacement des soldats
execute {
    writeln("Disposition des soldats dans le donjon :");

    for (var s in soldats) {
        for (var dir in cotes) {
            if (Regarde[s][dir] == 1) {
                // Affichage du soldat en fonction de sa direction
                writeln("S", s, " (", 
                    dir == 1 ? "Nord" : 
                    dir == 2 ? "Est" : 
                    dir == 3 ? "Sud" : 
                    dir == 4 ? "Ouest" :
                    dir == 5 ? "Nord-Est" : 
                    dir == 6 ? "Nord-Ouest" : 
                    dir == 7 ? "Sud-Est" : "Sud-Ouest", ")");
            }
        }
    }
}*/
