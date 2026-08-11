#include <iostream>
#include <utility>
#include <vector>
#include <fstream>
#include <algorithm>
#include <sstream>
#include <iterator>

using std::string;

class odd_even_ostream_iterator
{
		public:
				odd_even_ostream_iterator(std::ostream& odd_output, std::ostream& even_output)
						: m_even_ostream(even_output, " "), m_odd_ostream(odd_output, " ")
				{ }

				odd_even_ostream_iterator(const odd_even_ostream_iterator& other)
						: m_even_ostream(other.m_even_ostream), m_odd_ostream(other.m_odd_ostream)
				{ }

		odd_even_ostream_iterator& operator=(odd_even_ostream_iterator& other)
		{
				this->m_even_ostream = other.m_even_ostream;
				this->m_odd_ostream = other.m_odd_ostream;
				return *this;
		}

		odd_even_ostream_iterator& operator=(int value)
		{
				if (value % 2 == 0) {
						*m_even_ostream = value;
				} else {
						*m_odd_ostream = value;
				}
				return *this;
		}

		odd_even_ostream_iterator& operator*()
		{
				return *this;
		}

		odd_even_ostream_iterator& operator++()
		{
				return *this;
		}
		odd_even_ostream_iterator& operator++(int)
		{
				return *this;
		}

		~odd_even_ostream_iterator() { }

		private:
				std::ostream_iterator<int> m_even_ostream;
				std::ostream_iterator<int> m_odd_ostream;
};

int main()
{
		std::vector<int> numbers;
		std::istream_iterator<int> fi(std::cin);
		std::istream_iterator<int> eof;
		odd_even_ostream_iterator os(std::cout, std::cerr);
		std::copy(fi, eof, os);

    return 0;
}
