
/**************************************************************
 * Modèle pour le problème du sudoku nxn
 * Modèle naif Low
 **************************************************************/
using CP;

// --- Parametrage Solveur ---
execute {
    cp.param.searchType = "DepthFirst" ; 
    cp.param.workers = 1;
    cp.param.allDiffInferenceLevel = "Low" ; 
}

// --- Modèle ---
include "sudoku.mod";

// --- Main (pour trouver toutes les solutions + statistiques) ---
include "../shared/allSolutions_and_stats.mod";


