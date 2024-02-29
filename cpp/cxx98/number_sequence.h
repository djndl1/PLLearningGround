#ifndef NUMBER_SEQUENCE_H
#define NUMBER_SEQUENCE_H

#include <iostream>
#include <vector>

class number_sequence {
public:
    virtual ~number_sequence() { };

    number_sequence(int beg_pos, int len, std::vector<int>& elems)
        : m_beg_pos(beg_pos), m_length(len), m_relems(elems)
        { }

    /**
     * @brief element at pos
     * @param pos position
     * @returns element at pos
     */
    int operator[](int pos) const;

    /**
     * @brief identify the actual sequence
     */
    virtual const char* what_am_i() const = 0;

    /**
     * @brief write the elements to os
     */
    std::ostream& print(std::ostream &os = std::cout) const;

    /**
     * @brief sequence length
     * @returns sequence length
     */
    int length() const { return m_length; }

    /**
     * @brief the beginning position
     * @returns the beginning position
     */
    int beg_pos() const { return m_beg_pos; }

    /**
     * @brief maximum position supported
     */
    static int max_elems() { return _max_elemens; }

    protected:
    /**
     * @brief generate the elements up to pos
     */
    virtual void gen_elems(int pos) const = 0;

    /**
     * @brief is pos a valid value?
     */
    bool check_integrity(int pos, int size) const;

    const static int _max_elemens = 1024;

    int m_length;

    int m_beg_pos;

    std::vector<int> &m_relems;
};

std::ostream& operator<<(std::ostream &os, const number_sequence &ns)
{
    return ns.print(os);
}

class Fibonacci : public number_sequence
{
public:
    Fibonacci(int len = 1, int beg_pos = 1)
        : number_sequence(beg_pos, len, m_elems)
        { }

    virtual const char* what_am_i() const { return "Fibonacci"; }

protected:
    virtual void gen_elems(int pos) const;

    static std::vector<int> m_elems;
};

#endif
