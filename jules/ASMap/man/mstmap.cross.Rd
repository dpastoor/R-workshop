\name{mstmap.cross}
\alias{mstmap.cross}
\alias{mstmap}
\title{
Extremely fast linkage map construction for R/qtl objects using MSTmap.
}
\description{
Extremely fast linkage map construction for R/qtl objects utilizing the
source code for MSTmap (see Wu et al., 2008). The construction includes
linkage group clustering, marker ordering and genetic distance calculations.
}
\usage{
\method{mstmap}{cross}(object, chr, id = "Genotype", bychr = TRUE,
       suffix = "numeric", anchor = FALSE, ril.gen = 0,
       dist.fun = "kosambi", objective.fun = "COUNT", p.value = 1e-06,
       noMap.dist = 15, noMap.size = 0, miss.thresh = 1, mv.est = FALSE,
       detectBadData = FALSE, trace = FALSE, \ldots)
}
\arguments{
  \item{object}{
A \code{"cross"} object generated from the R/qtl package. Specifically
the object needs to inherit from one of the following classes
\code{"bc", "dh","riself","f2"} (see Details).
}
  \item{chr}{
A character string of linkage group names to be re-constructed and/or ordered
(see Details).
}
  \item{id}{
The name of the column in \code{object$pheno} representing the
genotypes. Default is \code{"Genotype"}.
}
\item{bychr}{
Logical value. For a given set of linkage groups defined by \code{chr},
if \code{TRUE} then split linkage groups (only if required, see
\code{p.value}) and order markers within linkage groups. If \code{FALSE} then combine
linkage groups and reconstruct the linkage map. Default is \code{TRUE}.
}
\item{suffix}{
Character string either \code{"numeric"} or \code{"alpha"} determining
whether numeric or alphabetic ascending values are post-fixed to linkage
group names when splitting linkage groups.
}
 \item{anchor}{
Logical value. The MSTmap algorithm does not respect the inputted marker
order of the linkage map required for construction. For a given set of
linkage groups defined by \code{chr}, if \code{TRUE} the order of the
inputted markers is respected regardless of the choices of \code{chr}
and \code{bychr}. Default is \code{FALSE}.
}
  \item{ril.gen}{
Numerical value defining the generation of RIL population. A
numerical value of x defines an F(x + 1) population. Default is zero
which assumes \code{object} is a backcross population.
}
  \item{dist.fun}{
Character string defining the distance function used fro calcualtion of
genetic distances. Options are "kosambi" and "haldane". Default is "kosambi".
}
  \item{objective.fun}{
Character string defining the objective function to be used when
constructing the map. Options are \code{"COUNT"} for minimising the sum of
recombination events between markers and \code{"ML"} for maximising the
likelihood objective function. Default is \code{"COUNT"}.
}
  \item{p.value}{
Numerical value to specify the threshold to use when constructing
linkage groups. Defaults to \code{1e-06}. If a value greater than one
is given this feature is turned off and it is assumed that all marker
data inputted belong to the same linkage group (see Details).
}
  \item{noMap.dist}{
Numerical value to specify the smallest genetic distance a set of
isolated markers can appear distinct from other linked markers. Isolated
markers will appear in their own linkage groups and will be of size
specified by \code{noMap.size}.
}
 \item{noMap.size}{
Numerical value to specify the maximum size of isolated marker linkage
groups that have been identified using \code{noMap.dist}. This feature
can be turned off by setting it to 0. Default is 0.
}
\item{miss.thresh}{
Numerical value to specify the threshold proportion of missing marker
scores allowable in each of the markers. Markers above this threshold
will not be included in the linkage map. Default is 1.
}
\item{mv.est}{
Logical value. If \code{TRUE} the algorithm will estimate missing
markers scores before clustering markers into linkage groups. Default is
\code{FALSE}. (see Details.)
}
  \item{detectBadData}{
Logical value. If \code{TRUE} the aglorithm will attempt to detect
possible genotyping errors. If found, the errors will be printed in the file
specified by \code{trace} and the offending marker scores will be set to
missing (see Details). Default is \code{FALSE}
}
  \item{trace}{
An automatic tracing facility. If \code{trace = FALSE} then
minimal \code{MSTmap} output is piped to the screen during the algorithm.
If \code{trace = TRUE}, then detailed output from MSTmap is
piped to \code{"MSToutput.txt"}. This file is equivalent to the output that
would be obtained from running the MSTmap executable from the command line.
}
\item{\ldots}{
Currently ignored.
}
}
\details{
The \pkg{qtl} object needs to inherit one of the allowable classes
\code{"bc","dh","riself","f2"}. This provides a safeguard against
an attempt to construct a map for more complex populations that can
exist in \pkg{qtl}. Users should be aware when doubled haploid
populations are read in using \code{read.cross()} from the \pkg{qtl}
package they inherit the class \code{"bc"}.

MSTmap supports RILx populations, where x is the number of generations
of selfing. For any RIL population, if \code{read.cross()} is used to
form the R/qtl object then it will be given a class
\code{"f2"}. Populations that are genuine advanced RILs can be converted
using the \code{convert2riself} function available in the \pkg{qtl}
package. As all other RIL populations are not
explicitly supported in the \pkg{qtl} package, manipulation of these
populations with the package should proceed with caution.
For the purpose of accurate map construction, the appropriate generation
of the RIL needs to be added manually using the \code{ril.gen}
argument.

This method function is designed to be an "all-in-one" function that
will allow you to construct linkage maps extremely fast in multiple
different ways from the supplied cross \code{object}. Initially, the map
can be kept complete or a subset of selected linkage groups can be chosen
using the \code{chr} argument. Setting \code{bychr = FALSE} will
bulk the marker information for the selected linkage groups and, if
necessary, form new linkage groups and optimise the marker order within
each. Setting \code{bychr = TRUE} will ensure that markers
are optimally ordered within each linkage group. This will also break
linkage groups depending on the p-value given in the call (see
below for details of the use of \code{p.value}). If the
linkage map was initially subsetted, the linkage groups not involved in
the subset are returned to ensure the map is complete.

The algorithm allows an adjustment of the \code{p.value} threshold for
clustering of linkage groups (see Wu et al., 2008). The default should
provide a suitable choice for most linkage maps when initially
clustering linkage groups or reconstructing components of the linkage
map. When \code{bychr = TRUE}, this default may also split formed
linkage groups where there is weak linkage. To prevent this the \code{p.value} threshold
may be inceased to a desired value or the splitting may be prevented
altogether by supplying a value greater than one to this argument.

Imputation of missing values is achieved using an EM algorithm that is
tightly coupled with marker ordering (see Wu et al., 2008). Initially
a marker order is obtained omitting missing marker scores and then
imputation is performed based on the underlying recombination fractions
of the flanking markers with the marker containing the missing
value. The recombination fractions are then recomputed and the order of
the markers is rechecked. This algorithm is repeated until convergence.

The algorithm can also detect possible genotyping errors. For any
individual genotype, the detection method is
based on a weighted Euclidean metric (see Wu et al., 2008) that is a function of the
recombination fractions of all the markers with the marker containing
the suspicious observation. Any genotyping errors detected are set to
missing and can be estimated using \code{mv.est}.
}
\value{The function returns a cross object with an identical class
  structure to the cross \code{object} inputted. The object is a list
  with usual components \code{"pheno"} and \code{"geno"}. If markers were
  omitted for any reason during the construction, the object will also have an
  \code{"omit"} component with all omitted markers in a collated matrix.
}
\references{
Y. Wu, P. Bhat, T.J. Close, S. Lonardi, Efficient and Accurate
Construction of Genetic Linkage Maps from Minimum Spanning Tree of a
Graph Plos Genetics, Volume 4, Issue 10, 2008.
}
\author{
Julian Taylor, Dave Butler, Timothy Close, Yonghui Wu, Stefano Lonardi
}
\seealso{
\code{\link{mstmap.data.frame}} and \code{\link{breakCross}}
}
\examples{

data(exmap, package = "ASMap")

## bulking linkage groups and reconstructing entire linkage map

test1 <- mstmap(exmap, bychr = FALSE, dist.fun = "kosambi", trace = FALSE)
pull.map(test1)

## one linkage group at a time

test2 <- mstmap(exmap, bychr = TRUE, dist.fun = "kosambi", trace = FALSE)
pull.map(test2)

## impute missing data and detect genotyping errors, pipe output to file

test3 <- mstmap(exmap, bychr = FALSE, dist.fun = "kosambi", trace = TRUE,
         mv.est = TRUE, detectBadData = TRUE)
pull.map(test3)

}
\keyword{misc}
