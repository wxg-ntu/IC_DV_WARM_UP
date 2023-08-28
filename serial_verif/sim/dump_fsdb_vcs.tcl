global env
fsdbDumpfile "$env(TOP_LEVEL).fsdb"
fsdbDumpvars 0 "$env(TOP_LEVEL)"
fsdbDumpSVA 0 "$env(TOP_LEVEL)"
dump -add "$env(TOP_LEVEL)" -depth 0
run
