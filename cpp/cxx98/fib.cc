/** @file fib.cc */

#include <iostream>
#include <vector>
#include <exception>
#include <string>
#include <algorithm>
#include <numeric>
#include <limits>

#include <stdint.h>

static inline bool is_fib_size_ok(size_t len)
{
    return (len > 0) && (len < 1000);
}

/**
 * @brief generate a fibonacci number
 * @param pos the position of the requested number
 * @param result the requested result
 * @tparam sequence element type
 * @returns whether the computation succeeds
 */
template<typename T>
bool fib_func(size_t pos, T &result)
{
    if (!is_fib_size_ok(pos)) return false;

    T elem = 1;
    T n1 = 1, n2 =  1;

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
 * @brief generate a Fibonacci sequence of certain length
 * @param len the length of the sequence
 * @tparam sequence element type
 * @returns the generated sequence
 */
template<typename T>
std::vector<T> fibon_seq(size_t len)
{
    static std::vector<T> elems;

    if (!is_fib_size_ok(len)) {
        throw std::out_of_range("len must be between 0 and 50");
    }

    for (size_t ix = elems.size() + 1; ix <= len; ix++) {
        T result;
        if (fib_func(ix, result))
        {
            elems.push_back(result);
        }
        else
        {
            throw std::runtime_error("Failed to compute fibonacci");
        }
    }

    return elems;
}

/**
 * @brief print sequence of specified length
 * @param pos the length of the sequence
 */
void print_sequence(size_t pos)
{
    uint64_t result;
    size_t cnt = 1;
    while (pos >= cnt && fib_func(cnt, result)) {
        std::cout << result;
        if (pos > 0) {
            std::cout << ' ';
        }

        cnt++;
    }

    std::cout << '\n';
}

/**
 * @brief display a vector to a stream, by default the standard output
 * @param vec the vector to display
 * @param os the output stream
 * @tparam sequence element type
 */
template<typename T>
void display(const std::vector<T> &vec, std::ostream &os = std::cout)
{
    for (typename std::vector<T>::const_iterator it = vec.begin(); it < vec.end(); it++) {
        os << *it;
        if (it + 1 != vec.end()) {
            os << ' ';
        }
    }
    os << '\n';
}


int main()
{
    size_t pos = 0;
    std::cin >> pos;

    print_sequence(pos);
    std::vector<uint64_t> seq = fibon_seq<uint64_t>(pos);
    display(seq);

    return 0;
}
