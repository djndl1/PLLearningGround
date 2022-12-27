enum TestEnum {
    A, B, C, D
}

int main(string[] args)
{
    stdout.printf("Hello world\n");
    foreach (var arg in args) {
        stdout.printf(arg + "\n");
    }

    string s = TestEnum.A.to_string();
    stdout.printf("%s\n", s);


    string substr = s[1:10];
    stdout.printf("%s\n", substr);
    return 0;
}
