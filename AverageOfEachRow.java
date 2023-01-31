import java.util.Arrays;
import java.util.Random;

class Average {
    int array[][] = new int[4][4];
    Random random = new Random();
    
    public void Print(){
        for (int i = 0; i < array.length; i++) {
            for (int j = 0; j < array[i].length; j++) {
                array[i][j] = random.nextInt((10 - 1) + 1) + 1;
            }
        }
        int x=0;
       for (int i = 0; i < array.length; i++) { 
         for (int j = 0; j < array[i].length; j++) {
            System.out.print(array[i][j] + "\t");
            x = x+array[i][j];
         }
         System.out.println("The average of Row "+(i+1)+" is "+(x/4.0)); 
         //System.out.println(); 
      }
   }
    
    public static void main(String args[]) {
      Average object = new Average();
      object.Print();
}
    
}