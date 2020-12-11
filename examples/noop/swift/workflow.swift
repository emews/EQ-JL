
/**
   workflow.swift
   noop project
   Authors: Carmine Spagnuolo and Giuseppe D'Ambrosio
*/

import io;
import location;
import sys;
import files;
import julia;
import string;

import EQJL;

string emews_root = getenv("EMEWS_PROJECT_ROOT");
string path = argv("path");
string module = argv("module");

(void v) loop(location L)
{
  printf("Entering loop...");

  for (boolean b = true, int j = 1;
       b;
       b=c, j = j + 1)
  {
    message = EQJL_get(L);
    printf("swift: from EQJL: %s", message);
    boolean c;
    if (message == "FINAL")
    {
      printf("Exiting loop.") =>
        v = propagate() =>
        c = false;
    } else if (message == "EQJL_ABORT") {
        string why = EQJL_get(L);
        printf("Abort %s", why) =>
        v = propagate() =>
        c = false;
    }
    else
    {
      string params[] = split(message, ";");
      string results[];
      foreach p,i in params
      {
        results[i] = int2string(string2int(p) + 1);
      }
      data = join(results, ";");
      // printf("swift: result: %s", result);
      printf("swift: to EQJL:   %s", data);
      EQJL_put(L, data) => c = true;
    
    }
  }

}

main() {
  printf("SWIFT WORKFLOW STARTING...");

  location L = locationFromRank(1);
  EQJL_init_package(L, path, module) =>
  loop(L) =>
  EQJL_stop(L) =>
    printf("SWIFT WORKFLOW COMPLETE");
}
