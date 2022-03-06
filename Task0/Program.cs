using System;

namespace Task0
{
    public class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Console.WriteLine("Enter number: ");
                int n = int.Parse(Console.ReadLine());

                if (IsEven(n)) Console.WriteLine("This number is even!");
                else Console.WriteLine("This number is odd!");
            }
            catch(Exception e)
            {
                Console.WriteLine("Error. Invalid data entered.");
            }

            
        }

        public static bool IsEven(int n)
        {
            return (n % 2 == 0);
        }
    }
}
