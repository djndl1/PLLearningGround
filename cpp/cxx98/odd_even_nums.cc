#include <iostream>
#include <utility>
#include <vector>
#include <fstream>
#include <algorithm>
#include <sstream>
#include <iterator>

using std::string;

static void output_as(const std::string &filename, std::vector<int> nums, const std::string delimiter = " ")
{

    std::ofstream fs(filename.c_str());
    std::ostream_iterator<int> oi(fs, delimiter.c_str());

    std::copy(nums.begin(), nums.end(), oi);
    if (delimiter != "\n") {
        fs << '\n';
    }
}

int main()
{
    std::vector<int> odds;
    std::vector<int> evens;

    int num;
    while (std::cin >> num) {
        if (num % 2 == 0) {
            evens.push_back(num);
        } else {
            odds.push_back(num);
        }
    }

    output_as("odds.out", odds);
    output_as("evens.out", evens, "\n");

    return 0;
}
