#include <boost/container/vector.hpp>
#include <string>
#include <numeric>
#include <iostream>


int main()
{
    boost::container::vector<std::string> vec{"I", " ", "Use", " ", "Boost"};

    std::string claim = std::accumulate(vec.begin(), vec.end(), std::string{""});

    std::cout << claim << std::endl;

    return 0;
}
