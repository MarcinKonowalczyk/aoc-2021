import java.io.*;
import java.util.*;
import java.util.stream.Collectors;

public class day01_1 {

    public static void main(String args[]) {
        List<Integer> depths = null;
        try {
            // depths = load("data/full/day01_input.txt");
            depths = load("data/reduced/day01_input.txt");
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(1);
        }

        // List<Integer> diffs = windowed(depths, 2).stream().map(i -> i.get(1)-i.get(0)).collect(Collectors.toList());
        // System.out.println(diffs);
    
        long increases =  windowed(depths, 2).stream().map(i -> i.get(1)-i.get(0)).filter(i->i>0).count();
        System.out.println(String.format("increases = %d", increases));
    }

    public static <T> List<List<T>> windowed(List<T> list, Integer n) {
        List<List<T>> out = new ArrayList<List<T>>();
        for (int i = 0; i < (list.size() - n + 1); i++) {
            out.add(list.subList(i, i + n));
        }
        return out;
    }

    public static List<Integer> load(String filename) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader(filename));
        String st;
        List<Integer> depths = new ArrayList<Integer>();
        while((st = br.readLine()) != null) {
            depths.add(Integer.parseInt(st));
        }
        return depths;
    }

}