\name{statGen}
\alias{statGen}
\title{
Individual genotype statistics for an R/qtl cross object
}
\description{
Individual genotype statistics for the current linkage map
order of and R/qtl cross object
}
\usage{
statGen(cross, chr, bychr = TRUE, stat.type = c("xo","dxo","miss"), id = "Genotype")
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
both. \code{"miss"}. \code{"xo"} calculates the number of crossovers,
\code{"dxo"} calculates the number of double crossover and \code{"miss"}
calculates the number of missing values.
}
\item{id}{
Character string determinng the column of \code{cross$pheno} that
contains the genotype names.
}
}
\details{
This function is used in \code{profileGen} to plot any combination of
returned linkage map statistics on a single graphical display.
}
\value{
A list with elements named by the \code{stat.type} used in the call. If
\code{bychr = TRUE} then each element is a data frame of statistics with
columns named by the linkage groups. If \code{bychr = FALSE} then each
element is a vector of statistics named by the \code{stat.type}.
}
\author{
Julian Taylor
}
\seealso{
\code{\link{profileGen}}
}
\examples{

data(exmap, package = "ASMap")

## produce all genotype crossover and double crossover statistics

statGen(exmap, stat.type = c("xo","dxo"))

}
\keyword{misc}
