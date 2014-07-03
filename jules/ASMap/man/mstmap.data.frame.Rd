\name{mstmap.data.frame}
\alias{mstmap.data.frame}
\title{
Extremely fast linkage map construction for data frame objects using MSTmap.
}
\description{
Extremely fast linkage map construction for data frame objects utilizing the
source code for MSTmap (see Wu et al., 2008). The construction includes
linkage group clustering, marker ordering and genetic distance calculations.
}
\usage{
\method{mstmap}{data.frame}(object, pop.type = "DH", dist.fun = "kosambi",
      objective.fun = "COUNT", p.value = 1e-06, noMap.dist = 15,
      noMap.size = 0, miss.thresh = 1, mv.est = FALSE, detectBadData = FALSE,
      trace = FALSE, as.cross = TRUE, \ldots)
}
\arguments{
  \item{object}{
A \code{"data.frame"} object containing marker information. The
data.frame must explicitly be arranged with markers in rows and
genotypes in columns. Marker names are obtained from the \code{rownames} of the
\code{object} and genotype names are obtained from the \code{names}
component of the \code{object} (see Details).
}
\item{pop.type}{
Character string specifying the population type contained in the
\code{object}. A value of \code{"DH"} indicates a doubled haploid
or backcross population. A value of \code{"RILx"} where x is a numerical integer
indicates RIL population of generation x. Default is \code{"DH"}.
}
  \item{dist.fun}{
Character string defining the distance function used for calculation of
genetic distances. Options are \code{"kosambi"} and \code{"haldane"}.
Default is \code{"kosambi"}.
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
data inputted belong to the same linkage group.
}
  \item{noMap.dist}{
Numerical value to specify the smallest genetic distance a set of
isolated markers can appear distinct from other linked markers. Isolated
markers will appear in their own linkage groups ad will be of size
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
markers scores before clustering markers into linkage groups (see
Details). Default is \code{FALSE}.
}
\item{detectBadData}{
Logical value. If \code{TRUE} the aglorithm will attempt to detect
possible genotyping errors. If found, the errors will be printed in the file
specified by \code{trace} and the offending marker scores will be set to
missing (see Details). Default is \code{FALSE}.
}
  \item{trace}{
An automatic tracing facility. If \code{trace = FALSE} then
minimal \code{MSTmap} output is piped to the screen during the algorithm.
If \code{trace = TRUE}, then detailed output from MSTmap is
piped to "\code{MSToutput.txt}". This file is equivalent to the output that
would be obtained from running the MSTmap executable from the command line.
}
\item{as.cross}{
Logical value. If \code{TRUE} the constructed linkage map is returned as
a R/qtl cross object (see Details). If \code{FALSE} then the constructed
linkage map is returned as a \code{data.frame} with extra columns
indicating the linkage group, marker name/position and genetic distance.
Default is \code{TRUE}.
}
\item{\ldots}{
Currently ignored.
}
}
\details{
The data frame \code{object} must have an explicit format with markers
in rows and genotypes in columns. The marker names are required to be in
the \code{rownames} component and the genotype names are
required to be in the \code{names} component of the \code{object}. In
each set of names there must be no spaces. If spaces are detected they
are exchanged for a "-".

Each of the columns of the data frame must be of class
\code{"character"} (not factors). If converting from a matrix, this can
easily be achieved by using the \code{stringAsFactors = FALSE} argument
for any \code{data.frame} method. The allelic content of the markers
must be explicitly adhered to. For populations with two genotypes such
as doubled haploid populations and backcrosses the two allele types should
be represented as (\code{"A"} or \code{"a"}) and (\code{"B"} or
\code{"b"}). For RIL populations heterozygotes should be represented as
\code{"X"}. For all populations missing marker scores should be represented
as (\code{"U"} or \code{"-"}).

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

Users need to be aware that the \pkg{qtl} only supports advanced RIL
(minimal heterozygosity) populations. For this reason using \code{as.cross = TRUE}
will set the class of the cross object to an "f2" to ensure that
\pkg{qtl} knows there is heterozygosity. If the population is an
advanced RIL then users can use the conversion
function \code{convert2riself} avalaible with the \pkg{qtl}
package. For all other RIL populations further manipulation of these
the \pkg{qtl} package should proceed with caution.
}
\value{
  If \code{as.cross = TRUE} the function returns an R/qtl cross object with the appropriate
  class structure. The object is a list with usual components
  \code{"pheno"} and \code{"geno"}. If markers were
  omitted for any reason during the construction, the object will also have an
  \code{"omit"} component with all omitted markers in a collated matrix.

  If \code{as.cross = FALSE} the function returns an ordered data frame object
  with additional columns that indicate the linkage group, the position
  and marker names and genetic distance of the markers witin in each
  linkage group.
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
  \code{\link{mstmap.data.frame}}
}
\examples{

data(exmap, package = "ASMap")

## forming data frame object from R/qtl object

dfg <- t(do.call("cbind", lapply(exmap$geno, function(el) el$data)))
dimnames(dfg)[[2]] <- as.character(exmap$pheno[["Genotype"]])
dfg <- dfg[sample(1:nrow(dfg), nrow(dfg), replace = FALSE),]
dfg[dfg == 1] <- "A"
dfg[dfg == 2] <- "B"
dfg[is.na(dfg)] <- "U"
dfg <- cbind.data.frame(dfg, stringsAsFactors = FALSE)

## construct map

test1 <- mstmap(exmap, dist.fun = "kosambi", trace = FALSE)
pull.map(test1)

## let's get a timing on that ...

system.time(test1 <- mstmap(exmap, dist.fun = "kosambi", trace = FALSE))

}
\keyword{misc}
