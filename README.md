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

| day.part | test        | 100          | full          |
| -------- | ----------- | ------------ | ------------- |
| 01.1     | 7           | 53           | 1154          |
| 01.2     | 5           | 55           | 1127          |
| 02.1     | 150         | 14550        | 1728414       |
| 02.2     | 900         | 2040686      | 1765720035    |
| 03.1     | 198         | 3551456      | 3895776       |
| 03.2     | 230         | 2639400      | 7928162       |
| 04.1     | 4512        | 24814        | 51776         |
| 04.2     | 1924        | 3960         | 16830         |
| 05.1     | 5           | 121          | 5690          |
| 05.2     | 12          | 463          | 17741         |
| 06.1     | 5934        | 123776       | 371379        |
| 06.2     | 26984457539 | 557806792325 | 1674303997472 |
| 07.1     | 37          | 21990        | 326132        |
| 07.2     | 168         | 7146662      | 88612508      |
| 08.1     | 26          | 181          | 352           |
| 08.2     | 61229       | 464287       | 936117        |