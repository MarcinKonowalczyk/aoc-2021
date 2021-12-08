import java.io.*;
import java.util.*;

public class day02_2 {

  public static void main(String args[]) {
    // List<String> data = load("data/full/day02_input.txt");
    List<String> data = load("data/reduced/day02_input.txt");
    int N = data.size();

    String[] commands = new String[N];
    Integer[] arguments = new Integer[N];
    for (int i = 0; i < N; i++) {
      String[] parts = data.get(i).split(" ");
      commands[i] = parts[0];
      arguments[i] = Integer.parseInt(parts[1]);
    }

    int position = 0;
    int angle = 0;
    int depth = 0;
    for (int i = 0; i < N; i++) {
      int argument = arguments[i];
      switch (commands[i]) {
        case "forward":
          position += argument;
          depth += angle * argument;
          break;
        case "up":
          angle -= argument;
          break;
        case "down":
          angle += argument;
          break;
      }
    }

    int position_x_depth = position * depth;
    System.out.println(String.format("position = %d", position));
    System.out.println(String.format("depth = %d", depth));
    System.out.println(String.format("position_x_depth = %d", position_x_depth));
  }

  private static List<String> load(String filename) {
    List<String> data = new ArrayList<String>();
    try {
      BufferedReader br = new BufferedReader(new FileReader(filename));
      String line;
      while ((line = br.readLine()) != null) {
        data.add(line);
      }
    } catch (IOException e) {
      e.printStackTrace();
      System.exit(1);
    }
    return data;
  }
}
