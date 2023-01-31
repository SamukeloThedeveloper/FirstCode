import java.util.Arrays;
import java.util.Random;

class MaxMin {
    int array[][];
    
    Random random = new Random();
    int maxRow=0;
    int minCol=80;  //possible maximum number
    
    public MaxMin(int rows, int cols){
         int [][] array = new int[rows][cols];
        for (int r = 0; r < rows; r++){
            for (int c = 0; c < cols; c++){
                array[r][c] = random.nextInt(20);
            }
        }
        
        for (int r = 0; r < array[0].length; r++){
            for (int c = 0; c < array[0].length; c++){
                System.out.print(array[r][c]+"\t");
            }
            System.out.println();
        }
        int tmp =0;
        int index=0;
        for (int r = 0; r < array[0].length; r++){
            for (int c = 0; c < array[0].length; c++){
                tmp = tmp+array[r][c];
            }
            if(maxRow<tmp){
                maxRow = tmp;
                index = r+1;
            }
            tmp=0;
        }
        System.out.println("Row "+index+" has highest sum of: "+maxRow);
        
    }
    
    
    public static void main(String args[]) {
        
      MaxMin object = new MaxMin(4,4);
      //object.out();
      
    }
    
}