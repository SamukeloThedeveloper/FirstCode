using System;
using System.Collections.Generic;

public class ManagementSystem {
    
    Dictionary<string, int> db = new Dictionary<string, int>();

    public void Menu() {
        while (true) { 
            Console.Write("1. Add Stock\n2. Remove Stock\n3. Generate Report\n4. Exit\nEnter your Option: ");
            
            if (int.TryParse(Console.ReadLine(), out int option)) {
                switch (option) {
                    case 1:
                        Console.Write("Enter the product name: ");
                        string name = Console.ReadLine().Trim().ToLower();

                        Console.Write("Enter the product quantity: ");
                        if (int.TryParse(Console.ReadLine(), out int totalitem)) {
                            AddStock(name, totalitem);
                        } else {
                            Console.WriteLine("Not a valid quantity.");
                        }
                        break;

                    case 2:
                        Console.Write("Enter the product name: ");
                        string item = Console.ReadLine().Trim().ToLower();

                        Console.Write("Enter the product quantity: ");
                        if (int.TryParse(Console.ReadLine(), out int totalitems)) {
                            RemoveStock(item, totalitems);
                        } else {
                            Console.WriteLine("Not a valid quantity.");
                        }
                        break;

                    case 3:
                        GenerateReport();
                        break;

                    case 4:
                        Console.WriteLine("Exiting system...");
                        return;

                    default:
                        Console.WriteLine("Selected option is not valid.");
                        break;
                }
                Console.WriteLine();
            } else {
                Console.WriteLine("Selected option is not valid.");
                Console.WriteLine();
            }
        }
    }

    public void AddStock(string procName, int quantity) {
        if (!db.ContainsKey(procName)) {
            db.Add(procName, quantity);
        } else {
            db[procName] += quantity; 
        }
        Console.WriteLine($"{quantity} units added to {procName}.");
    }

    public void RemoveStock(string procName, int quantity) {
        if (db.ContainsKey(procName)) {
            if (db[procName] == 0) {
                Console.WriteLine($"{procName} is out of stock.");
            } else if (db[procName] >= quantity) {
                db[procName] -= quantity; 
                Console.WriteLine($"{quantity} units removed from {procName}.");
            } else {
                Console.WriteLine($"You cannot remove more than available. Only {db[procName]} {procName} left.");
            }
        } else {
            Console.WriteLine("We do not have this product in store.");
        }
    }

    public void GenerateReport() {
        Console.WriteLine("\n--- Stock Report ---");
        if (db.Count == 0) {
            Console.WriteLine("No stock available.");
        } else {
            foreach (var item in db) {
                Console.WriteLine($"{item.Key}\t: {item.Value}");
            }
        }
        Console.WriteLine();
    }

    public static void Main(string[] args) {
        ManagementSystem obj = new ManagementSystem();
        obj.Menu(); // Start the system
    }
}
