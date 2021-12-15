# line starting with '# data = ' specifies the input data file:
# # data = ./data/test/day01_input.txt
# data = ./data/full/day01_input.txt

# line starting with '# flags = ' specifies the flags passed to `jq` commands
# flags = --slurp

[., .[1:]] | transpose | .[:-1] # pairwise input
| map( .[0] - .[1] ) # 1st difference
| map( select( . < 0 ) | 1 ) | add # sum