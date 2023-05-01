public class Test {

    internal int a { get; set; }

    public void action_1() {
        lock (a) {
            int tmp = a;
            tmp++;
            a = tmp;
        }
    }

    public void action_2() {
        lock (a)
        {
            int tmp = a;
            tmp--;
            a = tmp;
        }
    }
}

[Compact]
public class TestCallables {
    public Test test = new Test();

    GLib.Thread;

    public int Value
    {
        get
        {
            return test.a;
        }
    }

    public void minus() {
        for (int i = 0; i < 1000000; i++) {
            test.action_2();
        }
    }

    public void plus() {
        for (int i = 0; i < 1000000; i++) {
            test.action_1();
        }
    }
}


int main()
{
    var callables = new TestCallables();
    var thread_one = new Thread<void>.try("One", callables.minus);
    var thread_two = new Thread<void>.try("Two", callables.plus);

    var callable2 = (owned) callables;

    thread_one.join();
    thread_two.join();

    stdout.printf("%d\n", callables.Value);

    return 0;
}