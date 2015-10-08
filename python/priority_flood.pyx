# -*- mode: python -*-
#cython: boundscheck=False
#cython: wraparound=False
# Comments above are special. Please do not remove.

cimport numpy as np
import numpy as np

cimport priority_flood_c

ctypedef np.float32_t float_t
ctypedef np.float64_t double_t
ctypedef np.int32_t int_t

def watersheds(np.ndarray[dtype=float_t, ndim=2, mode="c"] z, missing_value = 0):
    """Label watersheds based on Barnes' priority flood algorithm

    Parameters
    ----------
    - z: surface elevation, a 2D NumPy array (float)
    - missing_value: float, optional
        default to zero (sea level)

    Returns
    -------
    - labels : 2D Numpy int array
    """
    cdef np.ndarray[dtype=int_t, ndim=2, mode="c"] output
    output = np.empty_like(z, dtype='i')
    
    priority_flood_c.priority_flood_watersheds_wrapper(z.shape[1], z.shape[0], <float*>z.data, <int*>output.data, missing_value)
    return output

