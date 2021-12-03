const fs = require('fs')

// data_file = "./data_full/day1_input.txt"
data_file = "data/day1_input.txt"
const data = fs.readFileSync(data_file, 'utf8')
const depths = data.split('\n').map(item => parseInt(item, 10))
// console.log("depths = ", depths)

// https://stackoverflow.com/a/52222561/2531987
function windowed(arr, size) {
    let result = [];
    arr.some((el, i)=> {
        if (i + size > arr.length) return true;
        result.push(arr.slice(i, i + size));
    })
    return result;
}

getSum = (x,y)=>x+y
increases = 
    windowed(windowed(depths, 3), 2).reduce((a, p)=>{
        return a + (p[0].reduce(getSum) < p[1].reduce(getSum))
}, 0)

console.log("increases = ", increases)
