// ensemble des instances
{string} models = {
    "sudoku_all_naive.mod", 
    "sudoku_all_extended.mod",
    "sudoku_all_low.mod",
    "sudoku_all_medium.mod"
};

// ensemble des modèles
{string} instances = {
    "sudoku99.1.dat",
    "sudoku99.2.dat",
    "sudoku99.3.dat",
    "sudoku99.4.dat",
    "sudoku99.5.dat",
    "sudoku99.6.dat",
    "sudoku99.7.dat",
    "sudoku99.8.dat",
    "sudoku99.9.dat",
    "sudoku99.10.dat",
    "sudoku1616.1.dat"
};



main{

    var out_file = new IloOplOutputFile("temp.dat");
    out_file.writeln("Comparaison de modèles: \n");

    // parcours des instances
    for (model in thisOplModel.models ){

        // parcours des modèles pour chaque instance
        for(instance in thisOplModel.instances){

            var sourceModel = new IloOplModelSource(model); // charger les données du modèle
            var modelDef= new IloOplModelDefinition(sourceModel);

            var mainCp = new IloCP();

            mainCp.param.logVerbosity = "Quiet";
            mainCp.param.searchType = "DepthFirst";

            var mainOpl = new IloOplModel(modelDef,mainCp);
            var sourceInstance = new IloOplDataSource("./instances/" + instance);

            mainOpl.addDataSource(sourceInstance);
            mainOpl.generate();

            mainCp.startNewSearch();

            // tant que des solutions existent
            while (mainCp.next()) {
                mainOpl.postProcess();	
            }
            writeln("No (more) solution\n");
            
            //ecrire les  informations dans le fichier temp
            out_file.writeln("modèle : " + model + "  _______ Instance : "+ instance);
            out_file.writeln("Solve Time : ", mainCp.info.solveTime);
            out_file.writeln("Nb Solutions : ", mainCp.info.numberOfSolutions);
            out_file.writeln("TotalTime : ", mainCp.info.TotalTime);
            out_file.writeln("NbOfFails : ", mainCp.info.numberOfFails);
            out_file.writeln("");
            out_file.writeln("-------------------------------------------------------------------------");
            out_file.writeln("");

            // fermeture des fichiers
            mainOpl.end();
            sourceModel.end();
            mainCp.end();
            modelDef.end();
            sourceInstance.end();

        }
    }
    out_file.close();

}