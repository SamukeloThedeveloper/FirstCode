using System;
using System.Collections.Generic;

public class TemperatureConverter{
    
    public void UserInput(){
        bool exit = false;
        while(exit == false){
            Console.Write("1. for Celsius to Fahrenheit\n2. for Fahrenheit to Celsius\nEnter your option: ");
            if(int.TryParse(Console.ReadLine(), out int option) && (option ==1 | option == 2)){
                Console.Write("Enter the temperature: ");
                if(double.TryParse(Console.ReadLine(), out double temp)){
                    if(option == 1){
                        C_to_F(temp);
                    }else{
                        F_to_C(temp);
                    }
                    
                    Console.WriteLine();
                    Console.Write("Do you want to convert another temperature?\n1.Yes\n2.No\nAnswer: ");
                    if(int.TryParse(Console.ReadLine(), out int ans) && (ans ==1 | ans == 2)){
                        if(ans == 1){
                            exit = false;
                        }else{
                            exit = true;
                        }
                    }
                }else{
                    Console.WriteLine("Not a valid temperature.");
                    Console.WriteLine();
                }
            }else{
                Console.WriteLine("Not a valid option.");
                Console.WriteLine();
            }
        }
    }
    public void C_to_F(double temp){
        double tempF = (temp * 9 / 5) + 32;
        
        Console.WriteLine($"{temp}°C is {Math.Round(tempF, 2)}°F ");
    }
    public void F_to_C(double temp){
        double tempC = (temp -32) * 5 / 9;
        Console.WriteLine($"{temp}°F is {Math.Round(tempC, 2)}°C ");
    }
    public static void Main(string[] args){
        TemperatureConverter obj = new TemperatureConverter();
        obj.UserInput();
    }
}
