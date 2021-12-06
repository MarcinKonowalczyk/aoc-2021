using DelimitedFiles

data_file = "./data/reduced/day04_input.txt"
# data_file = "./data/full/day04_input.txt"
data = readdlm(data_file, String)

numbers = [parse(Int64, n) for n in split(data[1],',')]
boards = [parse(Int64, n) for n in data[2:end,:]]

@assert mod(size(boards,1),5) == 0 "invalid board specification. all boards must have height 5"

# reshae to easilly access each board
boards = permutedims(reshape(boards,(5,Int64(size(boards,1)/5),5)),(2,1,3))

# iterate through all the boards
masks, already_won = falses(size(boards)), falses(size(boards, 1))
winning_board, winning_number = undef, undef
for number in numbers,
    (board_index, (board, mask, won)) in enumerate(zip(
        eachslice(boards, dims=1), eachslice(masks, dims=1), eachslice(already_won, dims=1)
    ))
    if !won[1] & (number in board)
        mask .|= (board .== number)
        if any(any(sum(mask, dims=d) .== 5) for d in (2,1))
            won[1] = true
            global winning_board, winning_number = board_index, number
        end
    end
end

println("bingo! on board $winning_board with number $winning_number")

# find the score of the winnig board
board = boards[winning_board, :, :]
mask = masks[winning_board, :, :]

unmarked_sum = sum(board[.!mask])
board_score = unmarked_sum * winning_number

@show unmarked_sum
@show winning_number
@show board_score

answer = board_score