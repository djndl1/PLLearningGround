/** @file fib.cc */

#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <numeric>
#include <limits>

/**
 * @brief generate a fibonacci number
 * @param pos the position of the requested number
 * @param result the requested result
 * @returns whether the computation succeeds
 */
bool fib_func(size_t pos, uint32_t &result)
{
    if (pos == 0) return false;

    uint32_t elem = 1;
    uint32_t n1 = 1, n2 =  1;

    for (size_t idx = 3; idx <= pos; idx++) {
        elem = n1 + n2;
        n1 = n2;
        n2 = elem;

        if (n1 >= elem) {
            return false;
        }

    }
    result = elem;
    return true;
}

/**
 * @brief print sequence of specified length
 * @param pos the length of the sequence
 */
void print_sequence(size_t pos)
{
    uint32_t result;
    size_t cnt = 1;
    while (pos > cnt && fib_func(cnt, result)) {
        std::cout << result;
        if (pos > 0) {
            std::cout << ' ';
        }

        cnt++;
    }

    std::cout << '\n';
}

int main()
{
    size_t pos = 0;
    std::cin >> pos;

    print_sequence(pos);

    return 0;
}
