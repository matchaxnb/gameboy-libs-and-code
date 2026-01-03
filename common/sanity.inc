;; this contains sanity checks: it verifies that when a feature is enabled
;; the adequate parameters are defined
DEF _fail = 0
IF (USE_TRACKTITLES)
  IF !DEF(TRACKTITLES_MAX_LENGTH) || TRACKTITLES_MAX_LENGTH <= 0
    PRINTLN "USE_TRACKTITLES is one, you need to define a positive TRACKTITLES_MAX_LENGTH"
    REDEF _fail = 1
  ENDC
ENDC

IF (_fail > 0)
    FAIL "Some sanity checks failed. Not going on."
ENDC