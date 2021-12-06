const fs = require('fs')

data_file = "./data/full/day02_input.txt"
// data_file = "data/test/day02_input.txt"
const data = fs.readFileSync(data_file, 'utf8').split('\n')

const directions = data.map(i=>i.split(' ')).map(item=>({"direction": item[0][0], "magnitude": parseInt(item[1],10)}));

var init_state = {
    "position": 0, "angle": 0, "depth": 0
}

const state = directions.reduce((state, command)=>{
    switch (command.direction) {
        case 'f':
            state.position += command.magnitude;
            state.depth += state.angle * command.magnitude;
        break;
        case 'u': state.angle -= command.magnitude; break;
        case 'd': state.angle += command.magnitude; break;
    }
    return state
}, init_state );

position_x_depth = state.position * state.depth

console.log("position_x_depth =", position_x_depth);