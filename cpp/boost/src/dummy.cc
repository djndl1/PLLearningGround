#include <boost/container/vector.hpp>
#include <string>
#include <numeric>
#include <iostream>


int main()
{
    boost::container::vector<std::string> vec;
		vec.push_back("I");
		vec.push_back(" ");
		vec.push_back("Use");
		vec.push_back(" ");
		vec.push_back("Boost");

    std::string claim = std::accumulate(vec.begin(), vec.end(), std::string(""));

    std::cout << claim << std::endl;

    return 0;
}
