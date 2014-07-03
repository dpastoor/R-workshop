#include <Rdefines.h>
#include <cstdlib>
#include "constants.h"
#include "linkage_group_DH.h"
#include "genetic_map_DH.h"
#include "genetic_map_RIL.h"
#include <R.h>

SEXP elem(SEXP list, const char *str);

int trace;
extern "C" SEXP mst(SEXP Plist, SEXP data)
{
  SEXP map;
  string pop_type;
  genetic_map* barley;

  trace = INTEGER(elem(Plist, "trace"))[0];

  pop_type = CHAR(STRING_ELT(elem(Plist, "population_type"),0));
  if (pop_type == "DH")
    barley = new genetic_map_DH();
  else
    barley = new genetic_map_RIL();

  barley->read_raw_mapping_data(Plist, data);
  barley->generate_map();
  barley->write_output(map);

  //delete barley;

  return(map);
}

void print_vector(vector<int> tmp)
{
  for (unsigned int ii = 0 ; ii < tmp.size(); ii++)
    {
      Rprintf("%d,", ii);
    }
  Rprintf("\n");
}
