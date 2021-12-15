# # data = ./data/test/day03_input.txt
# data = ./data/full/day03_input.txt
# flags = --raw-input --slurp

def pow2(f): f | reduce range(f) as $item (1; . * 2);

split("\n") | map(explode | map(.-48) ) # array of arrays of digits
| [(length | . / 2), reduce .[] as $item ([0,0,0,0,0]; [., $item] | transpose | map(add) )] # sum all the bits in columns
| .[0] as $len | .[1] | map((if . > $len then 1 else 0 end)) # get gamma bits
| map((if .==1 then [1,0] else [0,1] end)) | transpose # convert to epsilon bits by negating gamma bits
| map(reverse) | map(( . | length) as $len | [., [range($len) | pow2(.)]] | transpose | map( .[0] * .[1] )) # elementwise multiply by powers of 2
| map(add) | { "gamma_rate": .[0], "epilon_rate": .[1] } # get the gamma and epsilor rates
| .power_consumption = (.gamma_rate * .epilon_rate) # output