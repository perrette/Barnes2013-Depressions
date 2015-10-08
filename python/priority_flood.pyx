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

cdef check_dimensions(z, mask):
    # z and mask are typed, so z.shape is not a Python object.
    # This means that we have to compare z.shape[0,1] to mask.shape[0,1] 'by hand'.
    if not (z.shape[0] == mask.shape[0] and z.shape[1] == mask.shape[1]):
        raise ValueError("arguments z and mask have to have the same shape: got (%d,%d) and (%d,%d)" %
                         (z.shape[0], z.shape[1], mask.shape[0], mask.shape[1]))

    # if My != z.shape[0]:
    #     raise ValueError("the size of y has to match the number of rows in z")
    #
    # if Mx != z.shape[1]:
    #     raise ValueError("the size of x has to match the number of columns in z")

def watershed(np.ndarray[dtype=float_t, ndim=2, mode="c"] z,
              np.ndarray[dtype=int_t, ndim=2, mode="c"] mask,
              missing_value = 0,
              copy = False):
    """
    Computes the upslope area of points marked in the mask argument.

    Ice-free cells should be marked with -1, icy cells to be processed with -2,
    cells at termini (icy or not) with positive numbers, one per terminus.

    Try initialize_mask(thickness) if you don't know where termini are.

    arguments:
    - z: surface elevation, a 2D NumPy array (float)
    - mask: mask, integers, a 2D NumPy array
    - missing_value: float, optional
        default to zero (sea level)
    - copy: boolean; False if the mask is to be modified in place
    """
    cdef np.ndarray[dtype=int_t, ndim=2, mode="c"] output

    check_dimensions(z, mask)

    if copy:
        output = mask.copy()
    else:
        output = mask

    # Mx == z.shape[1]
    priority_flood_c.priority_flood_watersheds_wrapper(z.shape[1], z.shape[0], <float*>z.data, <int*>output.data, missing_value)

    return output

