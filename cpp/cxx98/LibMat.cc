#include "LibMat.h"

#include <iostream>
#include <utility>
#include <algorithm>
#include <iterator>

using std::cout;
using std::string;
using std::endl;

LibMat::LibMat()
{
    cout << "LibMat::LibMat() default constructor!\n";
}

LibMat::~LibMat()
{
    cout << "LibMat::~LibMat() destructor!\n";
}

void LibMat::print() const
{
    cout << "libMat::print() -- Im am a LibMat object!\n";
}

Book::Book(const std::string &title, const std::string &author)
    : m_title(title), m_author(author)
{
    cout << "Book::Book(" << m_title << ", " << m_author << ") constructor\n";
}

Book::~Book()
{
    cout << "Book::~Book() destructor\n";
}


void Book::print() const
{
    cout << "Book::print() -- I am a Book object\n"
        << "Title: " << m_title << '\n'
        << "Author: " << m_author << '\n';
}

AudioBook::AudioBook(const std::string &title,
                     const std::string &author,
                     const std::string &narrator)
    : Book(title, author),
      m_narrator(narrator)
{
    cout << "AudioBook::AudioBook("
         << this->title() << ", " << this->author()
        << ", " << m_narrator << ") cosntructor\n";
}

AudioBook::~AudioBook()
{
    cout << "AudioBook::~AudioBook() destructor!\n";
}

void AudioBook::print() const
{
    cout << "AudioBook::print() -- I am an AudioBook object!\n"
         << "My title is: "
         << title() << '\n'
         << "My author is: "
         << author() << '\n'
         << "My narrator is: " << m_narrator << endl;
}

int main()
{
    LibMat ab = AudioBook("Mason and Dixon",
                          "Thomas Pynchon", "Edwin Leonard");

    ab.print();

    return 0;
}
