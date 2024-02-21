/** @file bubble_sort.cc */

#include <algorithm>
#include <numeric>
#include <iostream>
#include <string>
#include <vector>

using std::vector;
using std::string;

/**
 * @brief display a vector to a stream, by default the standard output
 * @param vec the vector to display
 * @param os the output stream
 */
void display(const std::vector<int> &vec, std::ostream &os = std::cout)
{
    for (std::vector<int>::const_iterator it = vec.begin(); it < vec.end(); it++) {
        os << *it;
        if (it + 1 != vec.end()) {
            os << ' ';
        }
    }
    os << '\n';
}

/**
 * @brief an in-place bubble sort of vector
 * @param vec the vector to sort
 */
void bubble_sort(std::vector<int> &vec)
{
    for (int ix = 0; ix < vec.size(); ix++) {
        for (int jx = ix + 1; jx < vec.size(); jx++) { // find the minimum of the right part
            if (vec[ix] > vec[jx]) {
                std::swap(vec[ix], vec[jx]);
            }
        }
    }
}

int main()
{
    int ia[] = { 8, 34, 3, 13, 1, 21, 5, 2};
    vector<int> vec(ia, ia + sizeof(ia) / sizeof(ia[0]));

    bubble_sort(vec);

    display(vec);

    return 0;
}
