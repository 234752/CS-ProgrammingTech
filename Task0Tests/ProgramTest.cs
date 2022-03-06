using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Task0;

namespace Task0Tests
{
    [TestClass]
    public class ProgramTest
    {
        [TestMethod]
        public void IsEvenTest()
        {
            Assert.IsTrue(Program.IsEven(512));
        }
    }
}
