# -*- mode: python -*-

cdef extern from "../src/priority_flood_wrapper.hpp":
    bint priority_flood_watersheds_wrapper(int Mx, int My, float *elevation, int *labels, float missing_value)
