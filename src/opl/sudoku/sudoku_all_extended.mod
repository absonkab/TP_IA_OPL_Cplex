/**************************************************************
 * Modèle pour le problème du sudoku n x n
 * Propagation avancée avec la contrainte globale allDifferent
 **************************************************************/
using CP;

// --- Parametrage Solveur + niveau d'inférence alldiff---
execute {
    cp.param.searchType = "DepthFirst" ; 
    cp.param.workers = 1;
    cp.param.allDiffInferenceLevel = "Extended" ; 
}


// --- Modèle ---
include "sudoku.mod";

// --- Main (pour trouver toutes les solutions + statistiques) ---
include "../shared/allSolutions_and_stats.mod";


