
/**
   EMEWS workflow.swift
*/

import assert;
import io;
import location;
import julia;
import string;
import sys;

import EQJL;

string emews_root = getenv("EMEWS_PROJECT_ROOT");
string path = argv("path");
string module = argv("module");

N = 10;

/** The objective function */
(string result)
task(string params)
{
  resultFunc = 
  """
  begin
  resultFunc(x,y) = begin
    result = sin(4*x)+sin(4*y)+-2*x+x^2-2*y+y^2
    end
  resultFunc(%s)
  end
  """;
  result = julia(sprintf(resultFunc, params));

}

location L = locationFromRank(turbine_workers()-1);

(void v)
handshake(string settings_filename)
{
  message = EQJL_get(L) =>
    v = EQJL_put(L, settings_filename);
  assert(message == "Settings", "Error in handshake.");
}

(void v)
loop(int N)
{
  for (boolean b = true;
       b;
       b=c)
  {
    message = EQJL_get(L);
    // printf("swift: message: %s", message);
    boolean c;
    if (message == "FINAL")
    {
      printf("Swift: FINAL") =>
        v = make_void() =>
        c = false;
      finals = EQJL_get(L);
      printf("Swift: finals: %s", finals);
    }
    else
    {
      string params[] = split(message, ";");
      string results[];
      foreach p,i in params
      {
        results[i] = task(p);
      }
      result = join(results, ";");
      // printf("swift: result: %s", result);
      EQJL_put(L, result) => c = true;
    }
  }

}

settings_filename = argv("settings");

printf("SWIFT WORKFLOW STARTING...")=>
  EQJL_init_package(L, path, module) =>
  handshake(settings_filename) =>
  loop(N) =>
  EQJL_stop(L) =>
  printf("SWIFT WORKFLOW COMPLETE");
