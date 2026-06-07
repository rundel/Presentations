## rgeos: spatial geometry predicates and topology operations in R

*Colin Rundel, Roger Bivand, Edzer Pebesma*

rgeos is a package that implements functionality for the manipulation and querying of spatial geometries using the Geometry Engine - Open Source (GEOS) C library. This package expands on existing spatial functionality in R through integration with sp spatial classes and transparently replaces gpclib which is encumbered by a licensing agreement allowing only non-commercial use. Additionally, rgeos includes functionality for spatial predicates and topology operations for non-polygon geometries like points, lines, linear rings, and heterogeneous geometry collections. Previously, these operations were not possible within R and required the use of external GIS tools like GRASS, PostGIS, or ArcGIS which significantly complicate spatial workflows.

This talk will discuss the basic usage of this package with a focus on real world use-cases from the R-sig-Geo mailing list. Additionally, we will cover some of the finer details of the GEOS library which will give insight into the most efficient approaches for employing rgeos. Finally, we will discuss future directions for the package with plans for additional features such as spatial indexes using GEOS' STRtree functionality and the addition of improvements made in GEOS 3.3.0.
