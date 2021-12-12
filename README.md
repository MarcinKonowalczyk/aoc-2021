# aoc-2021

<!-- <a href="#badge"><img alt="code style: prettier" src="https://img.shields.io/badge/code_style-prettier-ff69b4.svg?style=flat-square"></a> -->

[Advent of code 2021](https://adventofcode.com/2021) solutions.

The theme is to try to solve the challenges in Julia, and then in as many other programming languages starting with letter J.

## Julia

```bash
julia -e 'using JuliaFormatter; format(".")'
julia $FILENAME.jl
```

## Javascript

```bash
npx prettier --write .
node $FILENAME.js
```

## Java

```bash
find . -regex '.*\.java$' | xargs -L1 google-java-format -i
javac $FILENAME.java && java $FILENAME && rm $FILENAME.class
```

## Jelly


```bash
cat "$DATA" | jelly fu "$FILENAME"
cat "$FILENAME" | head -n1 | sed -r 's/(“\.?\/?|»)//g' | sed "s/^/${ROOT//\//\\/}\//" | xargs cat | jelly fu "$FILENAME"
```

## Answers

| day.part | test        | full          |
| -------- | ----------- | ------------- |
| 01.1     | 7           | 1154          |
| 01.2     | 5           | 1127          |
| 02.1     | 150         | 1728414       |
| 02.2     | 900         | 1765720035    |
| 03.1     | 198         | 3895776       |
| 03.2     | 230         | 7928162       |
| 04.1     | 4512        | 51776         |
| 04.2     | 1924        | 16830         |
| 05.1     | 5           | 5690          |
| 05.2     | 12          | 17741         |
| 06.1     | 5934        | 371379        |
| 06.2     | 26984457539 | 1674303997472 |
| 07.1     | 37          | 326132        |
| 07.2     | 168         | 88612508      |
| 08.1     | 26          | 352           |
| 08.2     | 61229       | 936117        |
| 09.1     | 15          | 528           |
| 09.2     | 1134        | 920448        |
| 10.1     | 26397       | 168417        |
| 10.2     | 288957      | 2802519786    |
| 11.1     | 1656        | 1729          |
| 11.2     | 195         | 237           |
| 12.1     | 10          | 4720          |
| 12.2     | 36          | 147848        |