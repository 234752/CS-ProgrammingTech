using System;

namespace Task0
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Enter number: ");
            Console.ReadLine();
        }

        public bool isEven(int n)
        {
            return (n % 2 == 0);
        }
    }
}
