/*********************************************
 * Modèle OPL Pour le problème des n-reines
 *********************************************/

using CP;			/* Utilisation du solveur CP-Solver */

/* Paramétrage du solveur /   / Ne pas oublier */
execute {
    cp.param.searchType = "DepthFirst" ; 
    cp.param.workers = 1;
}



/* Déclarations domaines et variables */
range habitations = 1..5;

range pays = 1..5;
range couleurs = 1..5;
range travaux = 1..5;
range boissons = 1..5;
range animaux = 1..5;

dvar int Nationalite[pays] in habitations; // 1: Anglaise, 2: Espagnol, 3: Japonais, 4: Italien, 5: Norvegien
// Nationalite[2] == 3 veut dire que l'espagnol est dans la maison 3

dvar int Couleur[couleurs] in habitations; // 1: rouge, 2: vert, 3: jaune, 4: bleue, 5: blanche
// Couleurs[1] = 2 veut dire que la maison 2 est rouge

dvar int Profession[travaux] in habitations; // 1: peintre, 2: sculpteur, 3: diplomate, 4: violoniste, 5: medecin
// Professions[3] = 1 veut dire que le diplomate est dans la maison 1

dvar int Boire[boissons] in habitations; // 1: thé, 2: café, 3: lait, 4: jus, 5: eau
// Boisson[4] = 5 veut dire que la personne qui boit du jus habite la 5eme maison

dvar int Animal[animaux] in habitations; // 1: chien, 2: escargots, 3: renard, 4: cheval, 5: zebre
// Animal[5]= 3 veut dire que la personne dans la maison 3 a un zebre


/* Contraintes */

constraints{

    // les nationalités sont toutes différentes
    forall( i in pays, j in pays: i!=j)
        Nationalite[i] != Nationalite[j];

    // les Couleurs de maisons sont toutes différentes
    forall( i in couleurs, j in couleurs: i!=j)
        Couleur[i] != Couleur[j];

    // les Professions sont toutes différentes
    forall( i in travaux, j in travaux: i!=j)
        Profession[i] != Profession[j];
    
    // les Boissons sont toutes différentes
    forall( i in boissons, j in boissons: i!=j)
        Boire[i] != Boire[j];
    
    // les animaux sont tous différents
    forall( i in animaux, j in animaux: i!=j)
        Animal[i] != Animal[j];

    // l'anglais habite la maison rouge
    Nationalite[1] == Couleur[1];

    //l 'espagnole possede un chien
    Nationalite[2] == Animal[1];

    //le japonais est peintre
    Nationalite[3] == Profession[1];

    //l'italien boit du thé
    Nationalite[4] == Boire[1];

    // le norvegien habite la 1ere maison à gauche
    Nationalite[5] == 1;

    // le propriétaire de la maison verte boit du café
    Couleur[2] == Boire[2];

    //la maison verte est à droite de la blanche
    Couleur[2] == Couleur[5] + 1;

    // le sculpteur eleve des escargots
    Profession[2] == Animal [2];

    //le diplomate habite la maison jaune
    Profession[3] == Couleur[3];

    //On boit du lait dans la maison du milieu
    Boire[3] == 3;

    //le norvégien habite à coté de la maison bleue
    Couleur[4] == 2;

    // le violoniste boit des jus de fruits
    Profession[4] == Boire[4];

    //le renard est dans la maison voisine du médécin
    (Animal[3] == Profession[5] +1) || (Animal[3] == Profession[5] - 1);

    // le cheval est à coté de celle du diplomate
    Animal[4] == Profession[3] + 1 || Animal[4] == Profession[3] - 1;
}


execute{
    //affichage de la solution

    for (var p in pays) {

        writeln("L'habitant de la maison ", Nationalite[p], " est ", 
            p == 1 ? "l'Anglais" : 
            p == 2 ? "l'Espagnol" : 
            p == 3 ? "le Japonais" :  
            p == 4 ? "l'Italien" : "le Norvegien"
        );
    }

    writeln("\n---------------------------------------------------------------------------\n")

    for (var a in animaux) {

        writeln("L'habitant de la maison ", Animal[a], " a pour animal ", 
            a == 1 ? "le chien" : 
            a == 2 ? "les escargots" : 
            a == 3 ? "le renard" :  
            a == 4 ? "le cheval" : "le zebre"
        );
    }

    writeln("\n---------------------------------------------------------------------------\n")

    for (var t in travaux) {

        writeln("L'habitant de la maison ", Profession[t], " est ", 
            t == 1 ? "le peintre" : 
            t == 2 ? "le sculpteur" : 
            t == 3 ? "le diplomate" :  
            t == 4 ? "le violoniste" : "le medecin"
        );
    }

    writeln("\n---------------------------------------------------------------------------\n")

    for (var c in couleurs) {

        writeln("La couleur de la maison ", Couleur[c], " est ", 
            c == 1 ? "rouge" : 
            c == 2 ? "verte" : 
            c == 3 ? "jaune" :  
            c == 4 ? "bleue" : "blanche"
        );
    }

    writeln("\n---------------------------------------------------------------------------\n")

    for (var b in boissons) {

        writeln("L'habitant de la maison ", Boire[b], " boit ", 
            b == 1 ? "du the" : 
            b == 2 ? "du cafe" : 
            b == 3 ? "du lais" :  
            b == 4 ? "du jus de fruits" : "de l'eau"
        );
    }

    writeln("\n---------------------------------------------------------------------------\n")
}