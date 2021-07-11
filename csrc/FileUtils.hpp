#pragma once

#include <string>
#include <vector>

namespace siglabs {
namespace file {

std::vector<uint32_t> file_read_hex(const std::string filename);
std::vector<uint8_t> file_read_hex_stream(const std::string filename);
std::vector<uint32_t> file_read_raw_uint32_t(const std::string filename);
std::vector<uint8_t> file_read_raw_uint8_t(const std::string filename);
void file_dump_double_python(const std::vector<double>& din, const std::string filename, const std::string varname="a");
void file_dump_vec(const std::vector<uint32_t>& din, const std::string filename, const bool print = true);
void file_dump_csv(const std::vector<uint32_t>& din, const std::string filename, const bool print = true);
void dumpVector32(const std::string filename, const std::vector<uint32_t>& data);
uint8_t hex_char(const uint8_t c);

}
}
