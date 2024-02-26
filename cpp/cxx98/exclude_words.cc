#include <string>
#include <iostream>
#include <iterator>
#include <set>
#include <map>

using std::cin;
using std::cout;
using std::set;
using std::map;
using std::string;
using std::ostream_iterator;

static std::set<std::string> make_excluded_words()
{
    string words[] = { "a", "an", "in", "or", "but", "and", "the" };

    return set<string>(words, words + sizeof(words) / sizeof(words[0]));
}

static set<string> excluded_words = make_excluded_words();

int main()
{
    map<string, unsigned> word_counts;

    string read_word;
    while (cin >> read_word) {
        if (excluded_words.find(read_word) != excluded_words.end()) {
            cout << "Try again: " << read_word << " is an excluded word.\n";
            continue;
        }

        word_counts[read_word]++;
    }

    cout << "Want to query some word count?\n";
    string answer;
    do {
        string word_to_query;
        cin >> word_to_query;
        if (word_counts.find(word_to_query) == word_counts.end()) {
            cout << word_to_query << ": " << 0 << '\n';
        } else {
            cout << word_to_query << ": " << word_counts[word_to_query] << '\n';
        }
    } while (cin >> answer && answer == "y");

    for (map<string, unsigned>::iterator it = word_counts.begin();
         it != word_counts.end();
         it++) {
        cout << it->first << ": " << it->second << '\n';
    }

    return 0;
}
