\name{exmap}
\alias{exmap}
\docType{data}
\title{Genotypic marker data for a doubled haploid wheat population in R/qtl format}
\description{Linkage map marker data for a doubled
  haploid population in the form of a constructed R/qtl object.
}
\usage{data(exmap)}
\format{This data relates to a linkage map of 599 markers genotyped on 218
  individuals. The linkage map consists of 23 linkage groups spanning
  the whole genome. Map distances have been
  estimated using \code{read.cross} with the \code{"kosambi"}
  mapping function. The data object has been originally constructed with
  MultiPoint and curated with MapManager and R/qtl. The data is in R/qtl
  format with a class structure \code{c("bc","cross")}. See
    \code{read.cross} documentation for more details on the
  format of this object.
}
\examples{

data(exmap, package = "ASMap")

}
\keyword{datasets}