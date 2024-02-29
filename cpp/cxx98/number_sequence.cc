#include "number_sequence.h"

#include <iostream>

bool number_sequence::check_integrity(int pos, int size) const
{
    if (pos <= 0 || pos > _max_elemens)
    {
        return false;
    }
    if (pos > size)
        gen_elems(pos);

    return true;
    return true;
}

std::vector<int> Fibonacci::m_elems;

int number_sequence::operator[](int pos) const
{
    if (!check_integrity(pos, m_relems.size()))
        return 0;
    return m_relems[pos-1];
}

void Fibonacci::gen_elems(int pos) const
{
    if (m_elems.empty())
    {
        m_elems.push_back(1);
        m_elems.push_back(1);
    }

    if (m_elems.size() < pos)
    {
        int ix = m_elems.size();
        int n_2 = m_elems[ix-2];
        int n_1 = m_elems[ix-1];
        for (; ix < pos; ++ix)
        {
            int elem = n_2 + n_1;
            m_elems.push_back(elem);
            n_2 = n_1;
            n_1 = elem;
        }
    }
}

std::ostream& number_sequence::print(std::ostream &os) const
{
    int elem_pos = m_beg_pos - 1;
    int end_pos = elem_pos + m_length;
    if (end_pos > m_relems.size())
        gen_elems(end_pos);
    while (elem_pos < end_pos)
        os << m_relems[elem_pos++] << ' ';
    return os;
}

void display(std::ostream &os, const number_sequence &ns, int pos)
{
    os << "The element at position "
       << pos
       << " for the "
       << ns.what_am_i() << " sequence is "
       << ns[pos] << std::endl;
}

int main()
{
    Fibonacci fib;
    for (int i = 1; i < 20; i++)
        display(std::cout, fib, i);

    return 0;
}
