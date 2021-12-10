import java.io.*;
import java.util.*;
import java.util.stream.Collectors;

public class day01_2 {

  public static void main(String args[]) {
    // List<Integer> depths = load("data/full/day01_input.txt");
    List<Integer> depths = load("data/test/day01_input.txt");
    long increases =
        windowed(
                windowed(depths, 3).stream()
                    .map(i -> i.stream().reduce(0, (x, y) -> x + y))
                    .collect(Collectors.toList()),
                2)
            .stream()
            .map(i -> i.get(1) - i.get(0))
            .filter(i -> i > 0)
            .count();
    System.out.println(String.format("increases = %d", increases));
  }

  private static <T> List<List<T>> windowed(List<T> list, Integer n) {
    List<List<T>> out = new ArrayList<List<T>>();
    for (int i = 0; i < (list.size() - n + 1); i++) {
      out.add(list.subList(i, i + n));
    }
    return out;
  }

  private static List<Integer> load(String filename) {
    List<Integer> depths = new ArrayList<Integer>();
    try {
      BufferedReader br = new BufferedReader(new FileReader(filename));
      String st;
      while ((st = br.readLine()) != null) {
        depths.add(Integer.parseInt(st));
      }
    } catch (IOException e) {
      e.printStackTrace();
      System.exit(1);
    }
    return depths;
  }
}
