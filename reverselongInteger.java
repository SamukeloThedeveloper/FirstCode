import java.util.*;

public class ReverseNumber {
    
    private static void reverse(int num) {
        if(num<10){
            System.out.print(num);
            return;
        }
        else {
            System.out.print(num%10);
            reverse(num/10);
        }
    }
    
    public static void main(String[] args) {
        
        Scanner sc = new Scanner(System.in);
        
        System.out.print("Enter your Number: ");
        int num = sc.nextInt();
        
        reverse(num);
    }
}