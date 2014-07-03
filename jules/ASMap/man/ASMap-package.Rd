\name{ASMap-package}
\alias{ASMap-package}
\alias{ASMap}
\docType{package}
\title{
Additional functions for linkage map construction and manipulation of R/qtl
objects.
}
\description{
Additional functions for linkage map construction and manipulation of R/qtl
objects. This includes extremely fast linkage map clustering and marker
ordering using MSTmap (see Wu et al., 2008).
}
\details{
\tabular{ll}{
Package: \tab fastMap\cr
Type: \tab Package\cr
Version: \tab 0.2\cr
Date: \tab 2013-06-17\cr
License: \tab GPL 2\cr
}
Welcome to the first released version of the ASMap package!

One of the fundamental reasons why this package exists was to implement
the Minimum Spanning Tree algorithm derived in Wu et al. (2008) (reference
below) for linkage map construction. The algorithm is lightning quick at
clustering and optimal marker ordering and can handle large numbers of
markesrs.

The package also contains
}
\author{
Julian Taylor, Dave Butler, Timothy Close, Yonghui Wu, Stefano Lonardi
Maintainer: Julian Taylor <julian.taylor@adelaide.edu.au>
}
\references{
Y. Wu, P. Bhat, T.J. Close, S. Lonardi, Efficient and Accurate
Construction of Genetic Linkage Maps from Minimum Spanning Tree of a
Graph Plos Genetics, Volume 4, Issue 10, 2008.
}
\keyword{package}
\seealso{
\code{\link[qtl]{qtl-package}}
}

