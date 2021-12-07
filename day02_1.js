const fs = require("fs");

// data_file = "./data/full/day02_input.txt";
data_file = "data/reduced/day02_input.txt"
const data = fs.readFileSync(data_file, "utf8").split("\n");

const directions = data
  .map((i) => i.split(" "))
  .map((item) => [item[0][0], parseInt(item[1], 10)]);

const state = directions.reduce(
  (state, command) => {
    switch (command[0]) {
      case "f":
        state[0] += command[1];
        break;
      case "u":
        state[1] -= command[1];
        break;
      case "d":
        state[1] += command[1];
        break;
    }
    return state;
  },
  [0, 0]
);

position_x_depth = state.reduce((x, y) => x * y);

console.log("position_x_depth =", position_x_depth);
