using System;

namespace Custom.Types
{
    public interface IHouse { }

    public class House
    {
        static House()
        {
            Console.WriteLine("Initializing the Custom.Types.House Type");
        }

        public House()
        {
            Console.WriteLine("Creating a Custom.Types.House Instance");
        }

        public virtual void ShowHouseType()
        {
            Console.WriteLine("Custom.Types.House");
        }
    }

    public class SpecialHouse : House
    {
        public SpecialHouse()
        {
            Console.WriteLine("Creating a Custom.Types.SpecialHouse Instance");
        }

        public override void ShowHouseType()
        {
            Console.WriteLine("Custom.Types.SpecialHouse");
        }
    }

    public static class Houses {  }

    public static class Program
    {
        static void Main()
        {
            House house = new House();
            House specialHouse = new SpecialHouse();

            specialHouse.ShowHouseType();

            return;
        }
    }
}