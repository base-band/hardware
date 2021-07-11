#include "FileUtils.hpp"

#include <iostream>
#include <iomanip>
#include <fstream>
#include <iterator>
#include <stdint.h>

#include "cpp_utils.hpp"

using namespace std;

namespace siglabs {
namespace file {


// reads every line in a file that has 32 bit hex values (WITHOUT 0x)
// this pairs with file_dump_vec()
std::vector<uint32_t> file_read_hex(const std::string filename) {
        fstream infile;
        infile.open(filename, fstream::in|fstream::out|fstream::app);

        std::vector<uint32_t> out;
        uint32_t a;
        infile >> std::hex;
        while (infile >> a)
        {
                out.push_back(a);
        }
        return out;
}




std::vector<uint8_t> file_read_hex_stream(const std::string filename) {
        fstream infile;
        infile.open(filename, fstream::in|fstream::out|fstream::app);

        std::vector<uint8_t> out;
        uint8_t a;
        uint8_t val;
        uint8_t b = 0;
        infile >> std::hex;
        bool state = false;
        while (infile >> a)
        {
            val = hex_char(a);
            // cout << (int)val << endl;
            if( !state ) {
                b = (val << 4);
            } else {
                b |= val;
                out.push_back(b);
                b = 0;
            }

            state ^= 1;
            // std::cout << (int)a << endl;
                // out.push_back(a);
        }
        return out;
}

std::vector<uint32_t> file_read_raw_uint32_t(const std::string filename) {
        ifstream infile;
        infile.open(filename, std::ios::binary);

        std::vector<uint32_t> out;
        uint32_t a;
        while (infile.read(reinterpret_cast<char*>(&a), 4))
        {
            out.push_back(a);
        }
        return out;
}


std::vector<uint8_t> file_read_raw_uint8_t(const std::string filename) {
        ifstream infile;
        infile.open(filename, std::ios::binary);

        std::vector<uint8_t> out;
        uint8_t a;
        while (infile.read(reinterpret_cast<char*>(&a), 1))
        {
            out.push_back(a);
        }
        return out;
}



// dumps out ascii HEX values, 8 characters per line (32 bits)
void file_dump_vec(const std::vector<uint32_t>& din, const std::string filename, const bool print) {
    if( print ) {
        std::cout << "opening " << filename << " for writing" << std::endl;
    }
    std::ofstream outFile(filename);

    if (outFile.is_open()){

        for(const auto w : din) {
            outFile << HEX32_STRING(w) << std::endl;
        }
        outFile.close();
    }
}

void file_dump_csv(const std::vector<uint32_t>& din, const std::string filename, const bool print) {
        int16_t ureal, uimag;

        if( print ) {
            std::cout << "opening " << filename << " for writing" << std::endl;
        }
        std::ofstream outFile(filename);

        if (outFile.is_open()){

                for(const auto w : din) {
                        ureal = w & 0xffff;
                        uimag = (w>>16) & 0xffff;

                        outFile << ureal << ", " << uimag << endl;

                        // outFile << HEX32_STRING(*it) << std::endl;
                }
                outFile.close();
        }
}

void file_dump_double_python(const std::vector<double>& din, const std::string filename, const std::string varname) {
        std::cout << "opening " << filename << " for writing" << std::endl;
        std::ofstream outFile(filename);

        if (outFile.is_open()){

                outFile << varname << " = [ \n";

                unsigned i = 0;

                for(const auto& w : din ) {
                    if( i != 0 ) {
                        outFile << ',';
                    }
                    outFile << w << '\n';
                    i++;
                }

            outFile << "] \n";

                outFile.close();
        }
}

void dumpVector32(const std::string filename, const std::vector<uint32_t>& data) {
    std::ofstream outFile(filename);

    if (outFile.is_open()) {
        for(const auto w : data) {
              outFile << HEX32_STRING(w) << std::endl;
        }
        outFile.close();
    }
}


uint8_t hex_char(const uint8_t c) {
    switch(c) {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            return c - '0';
        case 'a':
        case 'b':
        case 'c':
        case 'd':
        case 'e':
        case 'f':
            return c - 'a' + 0x0a;
        case 'A':
        case 'B':
        case 'C':
        case 'D':
        case 'E':
        case 'F':
            return c - 'A' + 0x0a;
        default:
            break;
    }
    return 0;
}



} // namespace
} // namespace
