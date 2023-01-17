import java.util.*;

class Factorial {
    
    public void Calculate_Factorial(){
        
        int answer = 1;
        
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter your number: ");     
        int number = sc.nextInt();          //taking input from the user
        
        if(number>=0){                     //checking if the number is 0 or positive, can't fine factorial of a negative number
            System.out.print("The Factorial of "+number+"!\t=>\t");
            while(number>0){                //checking if the number is still positive 
                answer = answer * number;   //answer multiply by number -1 
                number = number - 1;        //answer multiply by number -1
            }
            System.out.println(answer);
        }
        else{
            System.out.println(number+"! is Undefined !!!");
        }
        
    }
    public static void main(String[] args) {
        Factorial object = new Factorial();
        object.Calculate_Factorial();
    }
}