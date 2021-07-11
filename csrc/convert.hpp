#pragma once
#include <stdint.h>
#include <vector>
#include <chrono>
#include <string>
#include <complex>
#include <functional>
#include <iostream>
#include "HiggsStructTypes.hpp"

void ishort_to_double(const uint32_t ishort, double &n_imag, double &n_real);
double imag_real_angle(const double n_imag, const double n_real);
void ishort_to_parts(const uint32_t ishort, int16_t &imag, int16_t &real);
uint32_t parts_to_ishort(const int16_t imag, const int16_t real);
void ishort_to_parts_swapped(const uint32_t n, int16_t &imag, int16_t &real);
void gain_ishort(const double gain, const uint32_t in, uint32_t& out, bool& saturation);
std::vector<uint32_t> gain_ishort_vector(const double gain, const std::vector<uint32_t>& in, unsigned& saturations);

double ishort_to_angle(const uint32_t n);
uint32_t angle_to_ishort(const double angle, const double mag_coeff = 32767.0);
void subcarrier_data_sync(std::vector<uint32_t> *data, uint32_t sync, int subcarriers);
void new_subcarrier_data_sync(std::vector<uint32_t> *data, uint32_t sync, int subcarriers);
void new_subcarrier_data_load(std::vector<uint32_t> &constructed, const std::vector<uint32_t> &din, const unsigned subcarriers);
uint32_t packetSizeFromWord(const uint32_t w);
void packetLoadCharsFromWords(const std::vector<uint32_t> &din,std::vector<unsigned char>& buffer,int bufferSize,int pktSize);
std::vector<unsigned char> packetToBytes(const std::vector<uint32_t> &din, int &erase);
std::vector<unsigned char> packetToBytesHashMode(const std::vector<uint32_t> &din, int &erase, std::function<uint32_t(const std::vector<uint32_t>&)> hasher);
std::vector<unsigned char> cBufferPacketToCharVector(const unsigned char* buffer, const unsigned buf_max_size, const int nread);
std::vector<uint32_t> charVectorPacketToWordVector(const std::vector<unsigned char>& buf);
std::vector<unsigned char> wordVectorPacketToCharVector(const std::vector<uint32_t>& buf);
uint32_t bitMangleSliced(const uint32_t in);
uint32_t bitMangleSlicedQam16(const uint32_t in);
time_t steady_clock_to_time_t( std::chrono::steady_clock::time_point t );

std::vector<uint32_t> _file_read_hex(std::string filename);
void _file_dump_hex(std::vector<uint32_t> din, std::string filename);



std::vector<uint32_t> custom_event_to_vector(custom_event_t e);
custom_event_t vector_to_custom_event(std::vector<uint32_t> &vec);

unsigned count_bit_set(uint32_t v);

std::vector<std::vector<uint32_t>> generate_counter_for_sliced_buf(std::vector<uint32_t> sliced2, uint32_t counter);

template<bool T0>
uint32_t get_bit_pair_sliced(const std::vector<uint32_t> &slc, const unsigned subcarrier, const unsigned time, const unsigned enabled_subcarriers);


uint32_t extract_vertical_from_sliced(const std::vector<uint32_t> &slc, const int j, const int i, const unsigned enabled_subcarriers);
uint32_t extract_vertical_from_sliced_qam16(const std::vector<uint32_t> &slc, const int j, const int i, const unsigned enabled_subcarriers);

void IShortToComplexMulti(std::vector<std::complex<double>> &out, const uint32_t* const data, const size_t length);
void IShortToComplexMulti(std::vector<std::complex<double>> &out, const unsigned char *data, const size_t length);
void IShortToComplexMulti(std::vector<std::complex<double>> &out, const std::vector<uint32_t> &vec);

void complexToIShortMulti(std::vector<uint32_t> &out, const std::complex<double> *data, const size_t length);
void complexToIShortMulti(std::vector<uint32_t> &out, const unsigned char *data, const size_t length);
void complexToIShortMulti(std::vector<uint32_t> &out, const std::vector<std::complex<double>> &vec);

void rotateIShortMulti(std::vector<uint32_t> &out, const std::vector<uint32_t> &in, double rads);

void complexConjMult(
    std::vector<std::complex<double>> &out,
    const std::vector<std::complex<double>> &a,
    const std::vector<std::complex<double>> &b );

void complexMult(
    std::vector<std::complex<double>> &out,
    const std::vector<std::complex<double>> &a,
    const std::vector<std::complex<double>> &b );

uint32_t riscvATANComplex(const std::complex<double> cplx, const size_t shift=15);
uint32_t riscvATAN(uint32_t val, const size_t shift=15);

uint64_t time_to_usec(struct timeval t);
struct timeval time_from_msec(uint64_t msec);
struct timeval time_divide(struct timeval t, unsigned long div);
struct timeval time_multiply(struct timeval t, double mult);
uint64_t time_to_msec(struct timeval t);
struct timeval time_from_usec(uint64_t usec);
void unwrap_phase_inplace(std::vector<double>&in);

template<typename T>
T saturate(T val, T min, T max) {
    return std::min(std::max(val, min), max);
}

uint64_t riscv_mag2_ideal(const std::vector<uint32_t>& in, const unsigned shift);
std::vector<uint32_t> offsetWords(const std::vector<uint32_t> data, const unsigned length, const unsigned offset);
std::vector<uint8_t> wordsIntoChars(const std::vector<uint32_t> data, const unsigned length, const unsigned offset);

std::vector<uint32_t> fftAirSubcarrierTransform(const std::vector<uint32_t>& v);
std::vector<uint32_t> vectorInsertTrunk(const std::vector<uint32_t>& v, const unsigned counter_index, const uint32_t counter_start);


std::vector<uint32_t> stringToWords(const std::string &_in);


template<bool T0>
uint32_t get_bit_pair_sliced(const std::vector<uint32_t> &slc, const unsigned subcarrier, const unsigned time, const unsigned enabled_subcarriers) {
    const unsigned words_per_frame = enabled_subcarriers / 16;
    const unsigned start = time * words_per_frame;

    // options for the stuff below
    constexpr bool switch_bits = true;
    constexpr bool switch_shift = false;
    constexpr bool invert_bits = T0;

    // 128 / 2 / 16

    unsigned choose_word = subcarrier / 16;
    int choose_bit;
    choose_bit = (subcarrier - (choose_word * 16)) * 2;

    if( switch_shift ) {
        choose_bit = 32 - choose_bit;
    } else {

    }

    // std::cout << "start " << start << " choose_word " << choose_word << " choose_bit " << choose_bit << "\n";

    // uint32_t mask = 0x3;

    const unsigned idx = start + choose_word;

    if( idx > slc.size() ) {
        std::cout << "warning picking illegal index " << idx << ", " << slc.size() << std::endl;
    }

    uint32_t result = (slc[idx] >> choose_bit) & 0x3;

    if( switch_bits ) {
        if( result == 1 ) {
            // cout << "switch" << endl;
            result = 2;
        } else if( result == 2 ) {
            result = 1;
        }
    }

    if( invert_bits ) {
        result = (~result)&0x3;
    }

    return result;
}

