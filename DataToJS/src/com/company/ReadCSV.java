package com.company;

/**
 * Created by Shrinivas on 6/4/2015.
 */
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ReadCSV {

    public static void main(String[] args) {

        ReadCSV obj = new ReadCSV();
        obj.run();

    }

    public void run() {

        String csvFile = "orderedByZip.csv";
        BufferedReader br = null;
        String line = "";
        String csvSplitBy = ",";
        int selector = 0;
        try {

            br = new BufferedReader(new FileReader(csvFile));
            Set<List<List<String>>> dataSet = new HashSet<List<List<String>>>();
            Set<String> zipSet = new HashSet<String>();
            if(selector == 1) {
                System.out.print("var ");
                String s = "";
                while ((line = br.readLine()) != null) {

                    // use comma as separator
                    String[] data = line.split(csvSplitBy);

                    if(!zipSet.contains(data[0])) {
                        zipSet.add(data[0]);
                        if(s.length() > 3) {
                            System.out.print(s.substring(0, s.length() - 2));
                            System.out.print(s.substring(s.length() - 0, s.length()));
                        }
                        s = "";
                        s += "],";
                        s += "\n z" + data[0] + " = [";
                        s += "{x:" + data[1] + ", y:" + getSeconds(data[3]) + "}, ";
                    } else {
                        s += "{x:" + data[1] + ", y:" + getSeconds(data[3]) + "}, ";
                    }
                }
                System.out.print(s.substring(0, s.length() - 2));
                System.out.print(s.substring(s.length() - 0, s.length()));
                System.out.print("]");
                System.out.println();
            } else {
                while ((line = br.readLine()) != null) {

                    // use comma as separator
                    String[] data = line.split(csvSplitBy);
                    if(!zipSet.contains(data[0])) {
                        System.out.println("{" + "\n" + "values: z" + data[0] + ",");
                        System.out.println("key: \"" + data[0] + "\",");
//                        System.out.println("color: \"#" + generateRandomColor() + "\",");
//                        System.out.println("color: \"#ff7f0e\",");
//                        System.out.println("{" + "\n" + "key: \"" + data[0] + "\",");
                        System.out.println("disabled: true,");
                        System.out.println("strokeWidth: 1.25 \n },");
                        zipSet.add(data[0]);
                    }
                }

            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        System.out.println("Done");
    }
    public String generateRandomColor() {
        String code = ""+(int)(Math.random()*256);
        code = code+code+code;
        int  i = Integer.parseInt(code);
        return Integer.toHexString( 0x1000000 | i).substring(1).toUpperCase();
    }
    public int getSeconds(String hms) {
        String[] hmsParts = hms.split(":");
        int hours = Integer.parseInt(hmsParts[0]);
        int minutes = Integer.parseInt(hmsParts[1]);
        int seconds = Integer.parseInt(hmsParts[2]);
        int duration = 3600 * hours + 60 * minutes + seconds;
        return duration;
    }
}
