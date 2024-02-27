#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>
#include <iostream>

class Matrix4x4
{
    const static int Row = 4;
    const static int Column = 4;
    public:
        Matrix4x4() : _elems(16) { }

        double &operator()(int row, int col)
        {
            return _elems[Row * row + col];
        }

        double operator()(int row, int col) const
        {
            return _elems[Row * row + col];
        }

        friend Matrix4x4 operator+(const Matrix4x4 &lhs, const Matrix4x4 &rhs);

        friend std::ostream &operator<<(std::ostream &os, const Matrix4x4 &mat);

    private:
        std::vector<double> _elems;
};

Matrix4x4 operator+(const Matrix4x4 &lhs, const Matrix4x4 &rhs)
{
    Matrix4x4 sum;

    std::transform(lhs._elems.begin(), lhs._elems.end(),
                   rhs._elems.begin(),
                   sum._elems.begin(),
                   std::plus<double>());
    return sum;
}

std::ostream &operator<<(std::ostream &os, const Matrix4x4 &mat)
{
    for (size_t i = 0; i < mat._elems.size(); i++) {
        os << mat._elems[i];
        if (i % 4 == 3) {
            os << '\n';
        } else {
            os << ' ';
        }
    }

    return os;
}


int main()
{
    Matrix4x4 mat;
    mat(0, 0) = 0;
    mat(1, 1) = 1;

    Matrix4x4 mat2;
    mat2(2, 2) = 2;
    mat2(3, 3) = 3;

    Matrix4x4 sum = mat + mat2;

    std::cout << sum << '\n';
}
