import java.util.*;
import java.util.Random;

public class NumberGuessingGame {
    Scanner sc = new Scanner(System.in);
    Random rand = new Random();
    int [] LottoNumbers = new int[6];
    int [] YourNumbers = new int[6];
    
    public void CorrectNumbers(){
        // Obtain 6 numbers between [0 - 49].
        for(int i=0; i<6; i++){
            LottoNumbers[i] = rand.nextInt(50);
        }
    }
    
    public void YourGuess(){
        CorrectNumbers();
        int count = 0;
        
        while(count<6){
            System.out.println("Number "+(count+1)+": ");
            int x = sc.nextInt();
            if(x<=0 | x >= 50){
                System.out.println("Your pick must be between 1-49");
            }else{
                YourNumbers[count] = x;
                count = count +1;
            }
            
        }
    }
    //bubble sorting 
    public void Sorting(){
        YourGuess();
        for(int i=0; i<6; i++){
            for(int j=0; j<6; j++){
                if(LottoNumbers[i]<LottoNumbers[j]){
                    int tmp = LottoNumbers[i];
                    LottoNumbers[i] = LottoNumbers[j];
                    LottoNumbers[j] = tmp;
                }
                if(YourNumbers[i]<YourNumbers[j]){
                    int tmp = YourNumbers[i];
                    YourNumbers[i] = YourNumbers[j];
                    YourNumbers[j] = tmp;
                }
            }
        }
    }
    public void OutPut(){
        Sorting();
        System.out.print("Lotto Numbers\t: ");
        for(int i=0; i<6; i++){
            System.out.print(LottoNumbers[i]+" ");
        }
        System.out.println();
        System.out.print("Your Numbers\t: ");
        for(int i=0; i<6; i++){
            System.out.print(YourNumbers[i]+" ");
        }
    }
    
    public static void main(String[] args) {
        NumberGuessingGame object = new NumberGuessingGame();
        object.OutPut();
        
    }
}