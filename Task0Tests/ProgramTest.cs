using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Task0;

namespace Task0Tests
{
    [TestClass]
    public class ProgramTest
    {
        [TestMethod]
        public void IsEvenTest512()
        {
            Assert.IsTrue(Program.IsEven(512));
        }
        [TestMethod]
        public void IsEvenTest1337()
        {
            Assert.IsFalse(Program.IsEven(1337));
        }
    }
}
