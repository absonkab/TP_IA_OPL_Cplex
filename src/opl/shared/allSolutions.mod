/*********************************************
 * Bloc main pour calculer / afficher toutes les solutions
 * en les numérotant et en les séparant les unes des autres.
 *********************************************/
// TODO 

execute {

}

/* Section de contrôle de flux pour énumérer toutes les solutions */
main {
    thisOplModel.generate();
    cp.startNewSearch();
    
    // Boucle tant qu'il y a des solutions
    while (cp.next()) {
        thisOplModel.postProcess();
    }
}