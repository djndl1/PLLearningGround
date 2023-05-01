class NullableClass : Object {
    public int Value { get; set; }
}

int main() {
    NullableClass obj = new NullableClass() { Value = 0 };

    obj = null;

    return obj.Value;
}