Barnes2013-Depressions
======================

**Title of Manuscript**:
Priority-Flood: An Optimal Depression-Filling and Watershed-Labeling Algorithm
for Digital Elevation Models

**Authors**: Richard Barnes, Clarence Lehman, David Mulla

**Corresponding Author**: Richard Barnes (rbarnes@umn.edu)

**DOI Number of Manuscript**
[10.1016/j.cageo.2013.04.024](http://dx.doi.org/10.1016/j.cageo.2013.04.024)

**Code Repositories**
 * [Author's GitHub Repository](https://github.com/r-barnes/Barnes2013-Depressions)
 * [Journal's GitHub Repository](https://github.com/cageo)

This repository contains a reference implementation of the algorithms presented
in the manuscript above. These implementations were used in performing the
tests described in the manuscript.

There is source code for every pseudocode algorithm presented in the
manuscript. All the code can be compiled simply by running **make**. The result
is a program called **priority\_flood.exe**.

This program reads in a DEM file specified on the command line. The file may be
any ArcGrid ASCII file. The program will run one of the algorithms described in
the manuscript (and below), store the result in an output file, and report how
long this took.

The program is run by typing:

    ./priority_flood.exe <ALGORITHM NUMBER> <INPUT DEM>
    ./priority_flood.exe 3 input-data.asc

The algorithms available are described briefly below and in greater detail in
the manuscript.

 * **Algorithm 1: Priority-Flood** This algorithm alters the input DEM to
produce an output with no depressions or digital dams. Every cell which would
have been in a depression is increased to the level of that depression's
outlet, leaving a flat region in its place. It runs slower than Algorithm 2,
but is otherwise the same. The result is saved to **out-pf-original**.

 * **Algorithm 2: Improved Priority-Flood** This algorithm alters the input DEM
to produce an output with no depressions or digital dams. Every cell which
would have been in a depression is increased to the level of that depression's
outlet, leaving a flat region in its place. It runs slower than Algorithm 2,
but is otherwise the same. The result is saved to **out-pf-improved**.

 * **Algorithm 3: Priority-Flood+Epsilon** This algorithm alters the input DEM
to produce an output with no depressions or digital dams. Every cell which
would have been in a depression is increased to the level of that depression's
output, plus an additional increment which is sufficient to direct flow to the
periphery of the DEM. The result is saved to **out-pf-epsilon**.

 * **Algorithm 4: Priority-Flood+FlowDirs** This algorithm determines a D8 flow
direction for every cell in the DEM by implicitly filling depressions and
eliminating digital dams. Though all depressions are guaranteed to drain, local
elevation information is still used to determine flow directions within a
depression. It is, in essence, a depression-carving algorithm. The result is
saved to **out-pf-flowdirs**.

 * **Algorithm 5: Priority-Flood+Watershed Labels** For each cell _c_ in a DEM,
this algorithm determines which cell on the DEM's periphery _c_ will drain to.
_c_ is then given a label which corresponds to the peripheral cell. All cells
bearing a common label belong to the same watershed. The result is saved to
**out-pf-wlabels**.

**Algorithm 4: Priority-Flood+FlowDirs** and its output, **out-pf-flowdirs**,
use the D8 neighbour system to indicate flow directions. In this system all the
flow from a central cell is directed to a single neighbour which is represented
by a number according to the following system where 0 indicates the central
cell.

    234
    105
    876

The directory **src/** contains the source code for the reference
implementations. All the source code is drawn from the RichDEM hydroanalysis
package. At the time of writing, the entire RichDEM code base could be
downloaded from: [https://github.com/r-barnes](https://github.com/r-barnes)


Notes on the Manuscript
=======================
Work by Cris Luengo on the speed of various priority queue algorithms is
discussed in the manuscript. His website providing code for his
implementatations is [here](http://www.cb.uu.se/~cris/priorityqueues.html).


Python bindings
===============
Algorithm 5 can be used from python. First install the related python package:

    python setup.py install 

Example of use:

    # assume z has been loaded to disk, with single precision (__f__loat, not __d__ouble)
    # if necessary: z = np.asarray(z, dtype='f')
    # if nans are present: z[np.isnan(z)] = 0  

    import priority_flood
    labels = priority_flood.watersheds(z, missing_value=0)
