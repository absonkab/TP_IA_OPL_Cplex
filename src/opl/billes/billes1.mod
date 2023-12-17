/*********************************************
 * Modèle OPL Pour le problème des billes
 *
 * Dans ce modèle, chaque variable doit être déclarée explicitement
 * en gardant son nom d'origine dans votre formalisation
 *
 *********************************************/
 
using CP;			/* Utilisation du solveur CP-Solver */

/* Déclarations domaines et variables */
range ages = 4..7;

dvar int Anne in ages;
dvar int Bernard in ages;
dvar int Claudine in ages;
dvar int Denis in ages;
dvar int Bleue in ages;
dvar int Jaune in ages;
dvar int Noire in ages;
dvar int Rouge in ages;
dvar int Parc in ages;
dvar int Jardin in ages;
dvar int Chambre in ages;
dvar int Salon in ages;


/* Paramétrage du solveur */   /* Ne pas oublier */
execute {
    cp.param.searchType = "DepthFirst" ; 
    cp.param.workers = 1;
}
 


/* Contraintes */
constraints {
   // Tous les enfants ont des prenoms différents 
    Anne != Bernard;
    Anne != Claudine; 
    Anne != Denis;
    Bernard != Claudine;
    Bernard != Denis;
    Claudine != Denis;

    //Tous les enfants jouent à des endroits différents
    Parc != Jardin;
    Parc != Chambre;
    Parc != Salon;
    Jardin != Chambre;
    Jardin != Salon;
    Chambre != Salon;

    //Tous les enfants ont des billes différentes
    Bleue != Jaune;
    Bleue != Noire; 
    Bleue != Rouge;
    Jaune != Noire; 
    Jaune != Rouge;
    Noire != Rouge;

   // contrainte 1: 
   // Denis joue dans le parc 
   Denis == Parc;
   //et n'a pas 4 ans:
   Denis != 4;
   // contrairement à l’enfant qui a des billes bleues:
   Bleue == 4;

   // contrainte 2. La fille de 6 ans a des billes jaunes:
   Jaune == 6;
   Anne == 6 || Claudine == 6;

   // contrainte 3 L’enfant qui joue avec des billes noires est plus âgé que l’enfant qui joue 
   // dans le jardin
   Noire > Jardin;
   // mais plus jeune que Anne:
   Noire < Anne;

   // contrainte 4: Anne, qui joue dans sa chambre, 
   Anne == Chambre;
   //Anne a 1 an de plus que l’enfant qui joue dans le salon:
    Anne == Salon + 1;

}


/* Post-traitement (Affichage Solution) */
execute {
    writeln("Age de Anne est ", Anne);
    writeln("Age de Bernard est ", Bernard);
    writeln("Age de Claudine est ", Claudine);
    writeln("Age de Denis est ", Denis);

    writeln("Age de celui qui joue dans le parc est ", Parc);
    writeln("Age de celui qui joue dans le Jardin est ", Jardin);
    writeln("Age de celui qui joue dans le Chambre est ", Chambre);
    writeln("Age de celui qui joue dans le Salon est ", Salon);

    writeln("Age de celui qui a les billes bleues est ", Bleue);
    writeln("Age de celui qui a les billes jaunes est ", Jaune);
    writeln("Age de celui qui a les billes noires est ", Noire);
    writeln("Age de celui qui a les billes rouge est ", Rouge);
}

