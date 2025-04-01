using System;

class Student {
    
    public int studentNo;
    public string firstName;
    public string lastName;
    public int age;
    public Student Next;
    public Student Prev;
    
    public Student(int sdtNo, string fname, string lName, int ag){
        studentNo = sdtNo;
        firstName = fname;
        lastName = lName;
        age = ag;
        Next = null;
        Prev = null;
    }
}

class ClassRoom{
    private Student head;
    
    public void Insert(int sdtNo, string fname, string lName, int ag){
        Student newstr = new Student(sdtNo, fname, lName, ag);
        if(head == null){
            head = newstr;
            return;
        }
        
        Student temp = head;
        while(temp.Next != null){
            temp = temp.Next;
        }
        temp.Next = newstr;
        newstr.Prev = temp;
    }
    
    public void Delete(int key){
        if(head == null) return;
        
        Student temp = head;
        while(temp != null && temp.studentNo != key){
            temp = temp.Next;
        }
        
        if(temp == null) return;  //student not found
        
        if(temp.Prev != null){
            temp.Prev.Next = temp.Next; 
        }else{
            head = temp.Next;  //deleting the head
        }
        
        if(temp.Next != null){
            temp.Next.Prev = temp.Prev;
        }
    }
    public void DisplayForward(){
        Student temp = head;
        while(temp != null){
            Console.WriteLine($"ID:{temp.studentNo} Name: {temp.firstName} {temp.lastName} Age: {temp.age}");
            temp = temp.Next;
        }
    }
    
    public void DisplayBackward(){
        if(head ==null) return;
        
        Student temp = head;
        while(temp.Next != null){
            temp = temp.Next;
        }
        
        while(temp != null){
            Console.WriteLine($"ID:{temp.studentNo} Name: {temp.firstName} {temp.lastName} Age: {temp.age}");
            temp = temp.Prev;
        }
    }
    
}

class Program{
    
    static void Main(){
        ClassRoom room = new ClassRoom();
        room.Insert(1, "Sam", "Msane", 24);
        room.Insert(2, "Lindo", "Fa", 25);
        room.Insert(3, "Ide", "F", 24);
        room.Insert(4, "Phuthu", "F", 24);
        
        Console.WriteLine("Display Forward:");
        room.DisplayForward();

        Console.WriteLine("\nDisplay Backward:");
        room.DisplayBackward();

        Console.WriteLine("\nAfter Deleting ID 2:");
        room.Delete(2);
        room.DisplayForward();
    }
}
