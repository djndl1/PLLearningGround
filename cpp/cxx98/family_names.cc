#include <iostream>
#include <vector>
#include <map>
#include <utility>
#include <iterator>
#include <sstream>
#include <fstream>

using std::string;
using std::vector;
using std::map;
using std::cin;
using std::cout;

template<typename T>
void display(const std::vector<T> &vec, std::ostream &os = std::cout)
{
    std::ostream_iterator<T> oit(os, " ");

    std::copy(vec.begin(), vec.end(), oit);
    os << '\n';
}

int main()
{
    map<string, vector<string> > family_names;
    std::ifstream ifs("family_names.txt");

    string line;
    while (std::getline(ifs, line)) {
        std::istringstream iss(line);

        string surname;
        iss >> surname;

        family_names[surname] = vector<string>();

        string child_name;
        while (iss >> child_name) {
            family_names[surname].push_back(child_name);
        }
    }

    string answer_cont;
    cout << "want to query a family?\n";
    cin >> answer_cont;
    do {

        if (answer_cont == "n") {
            break;
        }
        string family_name_to_query;
        cin >> family_name_to_query;

        if (family_names.find(family_name_to_query) == family_names.end()) {
            cout << "No such family: " << family_name_to_query;
        } else {
            cout << family_name_to_query << ": ";

            vector<string> child_names = family_names[family_name_to_query];
            display(child_names);
        }

        cout << "want to query a family?\n";
    } while (cin >> answer_cont && answer_cont == "y");

    for (map<string, vector<string> >::iterator it = family_names.begin();
         it != family_names.end();
         it++) {
        cout << it->first << ": ";
        display(it->second);
    }
}
