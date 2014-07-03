\name{profileGen}
\alias{profileGen}
\title{
Profile individual genotype statistics for an R/qtl cross object
}
\description{
Profile individual genotype statistics for the current linkage map
order of and R/qtl cross object
}
\usage{
profileGen(cross, chr, bychr = TRUE, stat.type = c("xo", "dxo", "miss"),
           id = "Genotype", xo.lambda = NULL, ...)

}
\arguments{
 \item{cross}{
An R/qtl \code{cross} object with a class structure restricted to one of
\code{"bc"}, \code{"dh"}, \code{"riself"} or \code{"f2"}.
}
\item{chr}{
Character vector of linkage group names used for subsetting the
linkage map.
}
\item{bychr}{
Logical vector determining whether statistics should be plotted by
chromosome (see Details).
}
\item{stat.type}{
Character string of any combination of \code{"xo"} or \code{"dxo"} or
\code{"miss"}. \code{"xo"} calculates the number of crossovers,
\code{"dxo"} calculates the number of double crossover and \code{"miss"}
calculates the number of missing values.
}
\item{id}{
Character string determinng the column of \code{cross$pheno} that
contains the genotype names.
}
\item{xo.lambda}{
A numerical value for the expected rate of recombination. (see Details).
}
\item{\ldots}{
Other arguments to be passed to the high level lattice plot.
}
}
\details{
This function uses \code{statGen} to profile statistics for the
genotypes for the current order of the linkage map. Any combination of
\code{"xo"} or \code{"dxo"} or \code{"miss"} may be given to
simultaneous plot. If \code{bychr = TRUE} then the plots will be further partitoned by
linkage groups given by \code{chr}.

If a numerical value is given for \code{xo.lambda} then the
recombination count for each genotype is tested against the expected
recombination rate \code{xo.lambda} using a simple one-tailed test of a
poisson mean. Any lines that have a p-value less than than a family wise
error rate based on bonferroni adjustment of the usual alpha level of 0.05 are
annotated on the profiles being plotted.
}
\value{
A lattice panel plot with panels described by the \code{stat.type} given
in the call.
}
\author{
Julian Taylor
}
\seealso{
\code{\link{statGen}}
}
\examples{

data(exmap, package = "ASMap")

## profile all genotype crossover and double crossover statistics

profileGen(exmap, stat.type = c("xo","dxo"), xo.lambda = 25)

}
\keyword{misc}
