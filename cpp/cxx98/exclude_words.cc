#include <string>
#include <vector>
#include <iostream>
#include <algorithm>
#include <iterator>
#include <utility>
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

struct key_length_comparer {
    public:
        bool operator()(const std::pair<std::string, unsigned> &a,
                        const std::pair<std::string, unsigned> &b) const
        {
            return a.first.size() < b.first.size();
        }
};

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

    std::vector<std::pair<string, unsigned> > count_vec(word_counts.begin(), word_counts.end());

    std::sort(count_vec.begin(), count_vec.end(), key_length_comparer());

    for (std::vector<std::pair<string, unsigned> >::iterator it = count_vec.begin();
         it != count_vec.end();
         it++) {
        cout << it->first << ": " << it->second << '\n';
    }

    return 0;
}
