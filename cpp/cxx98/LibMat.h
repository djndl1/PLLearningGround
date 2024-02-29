#ifndef LIBMAT_H
#define LIBMAT_H

#include <string>

class LibMat
{
    public:
        LibMat();

        virtual ~LibMat();

        virtual void print() const;
};

class Book : public LibMat
{
    public:
        Book(const std::string &title, const std::string &author);

        virtual ~Book();

        virtual void print() const;

        const std::string& title() const
        {
            return m_title;
        }

        const std::string& author() const
        {
            return m_author;
        }

    private:
        std::string m_title;
        std::string m_author;
};

class AudioBook : public Book {
public:
        AudioBook(const std::string &title,
                  const std::string &author,
                  const std::string &narrator);

        virtual ~AudioBook();

        virtual void print() const;

        const std::string& narrator() const { return m_narrator; }
    protected:
        std::string m_narrator;
};

#endif
