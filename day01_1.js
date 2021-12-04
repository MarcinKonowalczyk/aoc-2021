const fs = require('fs')

// data_file = "./data_full/day01_input.txt"
data_file = "data/day01_input.txt"
const data = fs.readFileSync(data_file, 'utf8')
const depths = data.split('\n').map(item => parseInt(item, 10))
// console.log("depths = ", depths)

const diffs = []
for (let i = 0; i < depths.length; i++ ) {
    diffs.push(depths[i]-depths[i-1])
}
// console.log("diffs = ", diffs)

console.log("increases = ", diffs.map(x=>x>0).reduce((x,y)=>x+y))
