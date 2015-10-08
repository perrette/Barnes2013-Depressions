// Wrapper around functions so that it can be called from python.

#include "utility.h"
#include "data_structures.h"
#include "data_io.h"
#include "priority_flood.hpp"
#include <cstdio>
#include <string>
#include <sys/time.h>
#include <iostream>

using namespace std;

// initialize an array2d based from a pointer to array
template <class T>
void wrap_array(int Mx, int My, T *arr, array2d<T> &arr_intern, T missing_value) {
    // some dummy values that should have no influence on the program
    arr_intern.xllcorner = 0;
    arr_intern.yllcorner = 0;
    arr_intern.cellsize = 1;
    arr_intern.no_data = missing_value;
    // allocate size
    arr_intern.resize(Mx, My); 
    // copy elements
    for (int i=0; i<Mx; i++) {
        for (int j=0; j<My; j++) {
            arr_intern(i,j) = arr[j * Mx + i];
        }
    };
};

// copy an array 2-D back to our pointer of floats
template <class T>
void unwrap_array(int Mx, int My, T *arr, array2d<T> &arr_intern) {
    // copy elements
    for (int i=0; i<Mx; i++) {
        for (int j=0; j<My; j++) {
            arr[j * Mx + i] = arr_intern(i,j);
        }
    };
};

int priority_flood_watersheds_wrapper(int Mx, int My, float *elevation, int *labels, float missing_value) {

    float_2d elev_intern;
    int_2d lab_intern;

    // copy 2-D array to internal data structure
    // NOTE: a pointer like in PISM regional tools could simplify things
    wrap_array(Mx, My, elevation, elev_intern, missing_value);
    wrap_array(Mx, My, labels, lab_intern, -1);  // missing_value will be overwritten anyway

    priority_flood_watersheds(elev_intern, lab_intern, false);

    // Point to new data
    unwrap_array(Mx, My, labels, lab_intern);
    // labels = lab_intern(0,0); // vector of vector, could one just return the reference???

    return 0;
};
