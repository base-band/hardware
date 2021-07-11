#include "convert.hpp"

// define this before math.h to get M_PI (which is same as PI)
#define _USE_MATH_DEFINES
#include <math.h>
#include <assert.h>
#include <iostream>
#include <fstream>
#include <iomanip>

void ishort_to_double(const uint32_t n, double &n_imag, double &n_real) {
    uint16_t n_u = n&0xffff;
    int32_t n_s;
    if(n_u>=0x8000)
        n_s = n_u-0x10000;
    else
        n_s = n_u;

    n_real =n_s*1.0;
    
    n_u = (n>>16)&0xffff;

    if(n_u>=0x8000)
        n_s = n_u-0x10000;
    else
        n_s = n_u;

    n_imag = n_s*1.0;
}


double imag_real_angle(const double n_imag, const double n_real) {
    double atan_angle = 0.0;

    if(n_real!=0.0)
    {
        atan_angle = atan(n_imag/n_real);
    }
    else 
    {
        if(n_imag == 0.0)
        {
            atan_angle = 0.0;
        }
        else if(n_imag > 0.0)
        {
            atan_angle = M_PI/2;
        }
        else if (n_imag<0.0)
        {
            atan_angle = M_PI/(-2);
        }
    }

    if(n_real>=0.0)
    {
        return atan_angle;
    }
    else if( (n_real<0.0) && (n_imag>=0.0) )
    {
        return atan_angle+M_PI;
    }
    else if( (n_real<0.0) && (n_imag<0.0) )
    {
        return atan_angle-M_PI;
    }

    return atan_angle; // bjm: is this corret? how do we get here?
}


void ishort_to_parts(const uint32_t n, int16_t &imag, int16_t &real) {
    real = n&0xffff;
    imag = (n>>16)&0xffff;
}

uint32_t parts_to_ishort(const int16_t imag, const int16_t real) {
    return ((((int32_t)imag)<<16) & 0xffff0000) | (real&0xffff);
}


// swapped as in opposite from our normal
void ishort_to_parts_swapped(const uint32_t n, int16_t &imag, int16_t &real) {
    imag = n&0xffff;
    real = (n>>16)&0xffff;
}


double ishort_to_angle(const uint32_t n) {
    double n_imag;
    double n_real;
    ishort_to_double(n, n_imag, n_real);
    double atan_angle = imag_real_angle(n_imag, n_real);
    return atan_angle;
}

uint32_t angle_to_ishort(const double angle, const double mag_coeff) {
    const int32_t real_part = (int32_t)(cos(angle)*mag_coeff);
    const int32_t imag_part = (int32_t)(sin(angle)*mag_coeff);
    return (((uint32_t)(imag_part&0xffff))<<16) + ((uint32_t)(real_part&0xffff));
}


/// Will apply real only gain to an real,imag ishort sample
/// @param [in] gain : double value to gain by
/// @param [in] in : sample
/// @param [out] out : result
/// @param [out] saturation : did the gain result in saturation
/// NOTE: if gain is so insanly large that the value for real or imag goes larger than 2 Billion
/// this will actually wrap
void gain_ishort(const double gain, const uint32_t in, uint32_t& out, bool& saturation) {
    int16_t _imag;
    int16_t _real;
    ishort_to_parts(in, _imag, _real);

    int32_t imag = _imag;
    int32_t real = _real;

    imag *= gain;
    real *= gain;

    imag = saturate(imag, INT16_MIN, INT16_MAX);
    real = saturate(real, INT16_MIN, INT16_MAX);

    if(
           imag == INT16_MIN
        || imag == INT16_MAX
        || real == INT16_MIN
        || real == INT16_MAX ) {
        saturation = true;
    } else {
        saturation = false;
    }

    out = ((imag & 0xffff) << 16) | (real & 0xffff);
}

std::vector<uint32_t> gain_ishort_vector(const double gain, const std::vector<uint32_t>& in, unsigned& saturations) {
    std::vector<uint32_t> vec;
    vec.reserve(in.size());
    uint32_t out;
    bool sat;
    saturations = 0;
    for( const auto w : in ) {
        gain_ishort(gain, w, out, sat);
        if( sat ) {
            saturations++;
        }
        vec.push_back(out);
    }
    return vec;
}


void subcarrier_data_sync(std::vector<uint32_t> *data, uint32_t sync, int subcarriers) {
    uint32_t temp1, temp2;
    uint32_t sync_frame;
    for (int i = 30; i >= 0; i -= 2) {
        sync_frame = 0;
        temp1 = (sync >> i)&0x1;
        temp2 = (sync >> (i+1))&0x1;
        for (int j = 0; j < 32; j++){
            if(j<16){
                sync_frame = (sync_frame << 1)|(temp2);
            } else {
                sync_frame = (sync_frame << 1)|(temp1);
            }
        }
        for (int k = 0; k < subcarriers/16; k++) {
            data->push_back(sync_frame);
        }
    }
}

void new_subcarrier_data_sync(std::vector<uint32_t> *data, uint32_t sync, int subcarriers) {
    uint32_t temp1, temp2;
    uint32_t temp3;
    uint32_t sync_frame;
    for (int i = 30; i >= 0; i -= 2) {
        sync_frame = 0;
        temp1 = (sync >> i)&0x1;
        temp2 = (sync >> (i+1))&0x1;
        temp3 = (temp1) | (temp2<<1);
        for (int j = 0; j < 16; j++){
            sync_frame = (sync_frame << 2) | temp3;
        }
        for (int k = 0; k < subcarriers/16; k++) {
            data->push_back(sync_frame);
        }
    }
}

// int op_increase (int i) { return ++i; }

void new_subcarrier_data_load(std::vector<uint32_t> &constructed, const std::vector<uint32_t> &din, const unsigned subcarriers) {
    // uint32_t _bit_pair;
    uint32_t _sixteen_group;

    // bool fill = true;
    // int fill_mode = 1; // fill repeat
//                    0; // fill zero

    std::vector<uint32_t> bit_pair;
    // std::vector<uint32_t> sixteen_group;
    bit_pair.resize(128);
    // sixteen_group.resize(128);

    // uint32_t sync = 0;
    // sync = din[0];

    int running_j = 0;

    int n_max = 0;

    int factor = subcarriers/16;

    bool even_division = true;
    (void)even_division;
    n_max = din.size() / subcarriers;
    if( din.size() % subcarriers  != 0 ) {
        n_max++;
        even_division = false;
    }
    // std::cout << "n_max " <<n_max << std::endl;

    int progress = 0;

    for(int n = 0; n < n_max; n++ ) {
    // for a shift amount
        // sync = din[n*128];
        for (int i = 0; i < 16; i++) {
            int shift = 30 - i*2;
            // std::cout << i << std::endl;
            // _bit_pair = ;

            // pick 2 bits, msbs
            // for(int m = 0; m < 128; m++) {
            //     bit_pair[m] = ((din[running_m] >> i)&0x1) | (((din[running_m] >> (i+1))&0x1)<<1);
            //     running_m++; // is identical to m for first loop, afterwards is m+128, ie always increasing
            // }

            for (int k = 0; k < factor; k++) {

                _sixteen_group = 0; // data represending 16 adjacent subcarriers
                for (int j = 0; j < 16; j++){
                    // std::cout << "j: " << j << ", " ;
                    auto &sync = din[ running_j % 128 + n*128 ];
                    uint32_t rhs = ((sync >> shift)&0x1) | (((sync >> (shift+1))&0x1)<<1);

                    _sixteen_group = (_sixteen_group << 2) | rhs;

                    // auto idx = 0;
                    // sixteen_group[idx] = (sixteen_group[idx] << 2) | rhs;
                    running_j++;
                }

            // std::cout << "fac: " << factor << ", ";

            // k is each group of subcarriers
                constructed.push_back(_sixteen_group);
            }
            progress++;

        }
    }
}


// uses our method of packing a char packet into words
// returns a number in bytes.  you may need to ceil outside of this
// function
// return value of 0 is invalid
uint32_t packetSizeFromWord(const uint32_t data) {
    if( data == 0 ) {
        return 0;
    }
    uint32_t size = ((data >> 8) & 0xFF00) | ((data >> 24)&0xff);

    return size;
}

uint32_t packetSizeFromWordHash(uint32_t data) {
    if( data == 0 ) {
        return 0;
    }

    // see this mask from VerifyHash
    uint32_t size = data & 0xfff;

    return size;
}


void packetLoadCharsFromWords(
    const std::vector<uint32_t> &din,
    std::vector<unsigned char>& buffer,
    int bufferSize,
    int pktSize
    ) {

        buffer.resize(bufferSize);
        int wordCount = 0;
        for(int i = 0; i < pktSize; i++) {
            auto w = din[i];
            buffer[4*wordCount]=(w >> 0) & 0xFF;
            buffer[4*wordCount+1]=(w >> 8) & 0xFF;
            buffer[4*wordCount+2]=(w >> 16) & 0xFF;
            buffer[4*wordCount+3]=(w >> 24) & 0xFF;
            wordCount++;
        }
}


// if erase is positive
// call again with N bytes advance din din
// if erase is -1, there are no more ipv4 packets in the packet
std::vector<unsigned char> packetToBytes(const std::vector<uint32_t> &din, int &erase) {

    // for(auto w : din) {
    //     std::cout << w << std::endl;
    // }
    // std::cout << std::endl;
    
    int pktSize = -1; // in words
    int bufferSize = 0; // in bytes
    std::vector<unsigned char> buffer;
    if(true) {

        if( din.size() == 0 ) {
            erase = -1;
            return buffer;
        }

        auto data = din[0];

        if( data == 0 ) {
            erase = -1;
            return buffer;
        }

        // std::cout << "data: " << data << "\n";

        bufferSize = packetSizeFromWord(data); // number of bytes in the packet
        pktSize = ceil(bufferSize/4.0);        // number of words we used to represent it on the wire
        // std::cout << "Packet size words: " << pktSize << std::endl;
        // std::cout << "bufferSize: " << bufferSize << "\n";
    }

    constexpr int mtu = 1500;
    if( bufferSize > mtu || pktSize > (ssize_t)din.size() ) {
        erase = -1;
        return buffer;
    }

    packetLoadCharsFromWords(din, buffer, bufferSize, pktSize);


    erase = pktSize;

    return buffer;
}

std::vector<unsigned char> packetToBytesHashMode(const std::vector<uint32_t> &din, int &erase, std::function<uint32_t(const std::vector<uint32_t>&)> hasher) {
    int pktSize = -1; // in words
    int bufferSize = 0; // in bytes
    std::vector<unsigned char> buffer;


        if( din.size() <= 1 ) {
            erase = -1;
            return {};
        }

        auto hash_word     = din[0];
        auto packet_header = din[1];
        (void)packet_header;

        if( hash_word == 0 ) {
            erase = -1;
            return {};
        }

        bufferSize = packetSizeFromWordHash(hash_word); // number of bytes in the packet
        pktSize = ceil(bufferSize/4.0);                 // number of words we used to represent it on the wire

        // std::cout << "  inside hash word " 
        //     << hash_word << ", "
        //     << "pktSize " << pktSize
        //     << " din size " << din.size()
        //     << std::endl;

        if( pktSize <= 0 || pktSize > ((ssize_t)din.size()-1) ) {
            erase = -1;
            // std::cout << "bail a: "
            //     << "pktSize " << pktSize
            //     << " din size " << din.size()
            //     << std::endl;
            return {};
        }

        std::vector<uint32_t> cutPacket;
        cutPacket.assign (din.begin()+1,din.begin()+1+pktSize);

        auto calculatedHash = hasher(cutPacket);

        // std::cout << "  inside recalculated hash " << calculatedHash << std::endl;


        if( hash_word != calculatedHash ) {
            // std::cout << "hash mismatch\n";
            erase = pktSize+1;
            return {};
        }

    constexpr int mtu = 1500;
    if( bufferSize > mtu ) {
        erase = -1;
        return {};
    }

    packetLoadCharsFromWords(cutPacket, buffer, bufferSize, pktSize);


    erase = pktSize+1;

    return buffer;
}

std::vector<unsigned char> cBufferPacketToCharVector(const unsigned char* buffer, const unsigned buf_max_size, const int nread) {
    std::vector<unsigned char> char_vec;
    if( nread < 0 ) {
        return char_vec;
    }

    char_vec.resize(nread);
    for(int i = 0; i < nread; i++)
    {
        char_vec[i] = buffer[i];
    }

    return char_vec;
}

std::vector<uint32_t> charVectorPacketToWordVector(const std::vector<unsigned char>& buf) {
//     std::vector<unsigned char> char_vec;
//     return char_vec;

    // for(auto w : buf) {
    //     std::cout << (int) w << std::endl;
    // }
    // std::cout << std::endl;

        std::vector<uint32_t> constructed;
        for(unsigned i = 0; i < buf.size(); i = i + 4) {
            constructed.push_back( (buf[i+3]<<(3*8)) |
                       (buf[i+2]<<(2*8)) |
                       (buf[i+1]<<(1*8)) |
                       (buf[i]));
        }

        return constructed;
}

std::vector<unsigned char> wordVectorPacketToCharVector(const std::vector<uint32_t>& buf) {
    int erase;
    std::vector<unsigned char> ret = packetToBytes(buf,erase);
    return ret;
}



uint32_t bitMangleSliced(const uint32_t in) {

    const uint32_t tword = ~in;

    uint32_t uword = 0;
    for(unsigned int i = 0; i < 16; i++) {
        const uint32_t bits = (tword>>(i*2))&0x3;
        const uint32_t bitrev = ((bits&0x1)<<1) | ((bits&0x2)>>1);
        uword = (uword << 2) | bitrev;
    }

    return uword;
}

uint32_t bitMangleSlicedQam16(const uint32_t in) {

    const uint32_t tword = in;

    uint32_t uword = 0;
    for(unsigned int i = 0; i < 16; i++) {
        const uint32_t bits = (tword>>(i*2))&0x3;
        const uint32_t bitrev = ((bits&0x1)<<1) | ((bits&0x2)>>1);
        uword = (uword << 2) | bitrev;
    }

    return uword;
}




time_t steady_clock_to_time_t( std::chrono::steady_clock::time_point t )
{
    return std::chrono::system_clock::to_time_t(std::chrono::system_clock::now()
                                          + (t - std::chrono::steady_clock::now()));
}

std::vector<uint32_t> custom_event_to_vector(custom_event_t e) {
    std::vector<uint32_t> v;
    v.push_back(e.d0);
    v.push_back(e.d1);
    return v;
}

custom_event_t vector_to_custom_event(std::vector<uint32_t> &vec) {
    custom_event_t ret;

    assert(vec.size()==2);

    ret.d0 = vec[0];
    ret.d1 = vec[1];
    return ret;
}

// reads every line in a file that has 32 bit hex values (WITHOUT 0x)
// this pairs with file_dump_vec()
// COPIED FROM higgs_helper.hpp
std::vector<uint32_t> _file_read_hex(std::string filename) {
        std::fstream infile;
        infile.open(filename, std::fstream::in | std::fstream::out | std::fstream::app);

        std::vector<uint32_t> out;
        uint32_t a;
        infile >> std::hex;
        while (infile >> a)
        {
                out.push_back(a);
        }
        return out;
}

// dumps out ascii HEX values, 8 characters per line (32 bits)
// COPIED FROM higgs_helper.hpp

void _file_dump_hex(std::vector<uint32_t> din, std::string filename) {
#define ___HEX32_STRING(n) std::setfill('0') << std::setw(8) << std::hex << (n) << std::dec
    // uint32_t rtn;
    std::cout << "opening " << filename << " for writing" << std::endl;
    std::ofstream outFile(filename);

    if (outFile.is_open()){

        for(auto it = din.begin(); it != din.end(); it++) {
            outFile << ___HEX32_STRING(*it) << std::endl;
        }
        outFile.close();
    }
#undef ___HEX32_STRING
}


unsigned count_bit_set(uint32_t v) {

    unsigned int c; // c accumulates the total bits set in v
    for (c = 0; v; c++)
    {
        v &= v - 1; // clear the least significant bit set
    }

    return c;
}





#define SLICED_DATA_BEV_WRITE_SIZE_WORDS 9

static void __handle_load_vector_vector(std::vector<std::vector<uint32_t>>& sliced_words, const uint32_t *word_p, const size_t read_words) {

    for(size_t i = 0; i < read_words; i++) {

        if( i % SLICED_DATA_BEV_WRITE_SIZE_WORDS == 0 ) {
            // this branch enters 1 times for every OFDM frame

            // save the frame in index 0
            sliced_words[0].push_back(word_p[i]);
            sliced_words[0].push_back(0);
            sliced_words[0].push_back(0);
            sliced_words[0].push_back(0);
            sliced_words[0].push_back(0);
            sliced_words[0].push_back(0);
            sliced_words[0].push_back(0);
            sliced_words[0].push_back(0);
            // cout << "frame: " << word_p[i] << endl;
        } else {
            // this branch enters 8 times for every OFDM frame
            size_t j = (i % SLICED_DATA_BEV_WRITE_SIZE_WORDS) - 1;
            (void)j;

            sliced_words[1].push_back(word_p[i]);

            // cout << "data: " << HEX32_STRING(word_p[i]) << " <- " << j << endl;
        }
    }
    assert(sliced_words[0].size() == sliced_words[1].size());

    // cout << r.sliced_words[0].size() << endl;
    // cout << r.sliced_words[1].size() << endl;

}

std::vector<std::vector<uint32_t>> generate_counter_for_sliced_buf(std::vector<uint32_t> sliced2, uint32_t counter) {
    std::vector<std::vector<uint32_t>> as_iq;
    as_iq.resize(2);

    for(unsigned int i = 0; i < sliced2.size(); i+=8) {
        std::vector<uint32_t> prep = {
            counter, 
            sliced2[i+0],
            sliced2[i+1],
            sliced2[i+2],
            sliced2[i+3],
            sliced2[i+4],
            sliced2[i+5],
            sliced2[i+6],
            sliced2[i+7]
            };
        counter++;

        __handle_load_vector_vector(as_iq, prep.data(), prep.size());
    }
    return as_iq;
}




uint32_t extract_vertical_from_sliced(const std::vector<uint32_t> &slc, const int j, const int i, const unsigned enabled_subcarriers) {
    uint32_t demod_word = 0;

    for(int k = i; k < i+16; k++)
    {
        uint32_t demod_bits = get_bit_pair_sliced<true>(slc, j, k, enabled_subcarriers);
        demod_word = (demod_word<<2 | demod_bits);
    }

    return demod_word;
}

uint32_t extract_vertical_from_sliced_qam16(const std::vector<uint32_t> &slc, const int j, const int i, const unsigned enabled_subcarriers) {
    uint32_t demod_word = 0;

    for(int k = i; k < i+16; k++)
    {
        uint32_t demod_bits = get_bit_pair_sliced<false>(slc, j, k, enabled_subcarriers);
        demod_word = (demod_word<<2 | demod_bits);
    }

    return demod_word;
}

void IShortToComplexMulti(std::vector<std::complex<double>> &out, const std::vector<uint32_t> &vec) {
    IShortToComplexMulti(out, vec.data(), vec.size());
}

void IShortToComplexMulti(std::vector<std::complex<double>> &out, const unsigned char *data, const size_t length) {
    IShortToComplexMulti(out, (const uint32_t* const)data, length);
}
// data is a pointer to raw memory, length is the number of uint32_t we expect to find there (not number of bytes)
void IShortToComplexMulti(std::vector<std::complex<double>> &out, const uint32_t* const data, const size_t length) {
    constexpr double gain = 1.0 / 0x7fff;

    out.resize(0);
    out.reserve(length);

    int16_t re,im;
    for( size_t i = 0; i < length; i++ ) {
        uint32_t w = data[i];
        im  = ((w>>16) & 0xffff);
        re  = ((w & 0xffff));
        
        out.emplace_back(re*gain,im*gain);

        // dataView.setUint32(0, x, true);
        // const re = dataView.getInt16(0, true);
        // const im = dataView.getInt16(2, true);

        // const c = mt.complex(re*gain,im*gain);
        // ret.push(c);
    }
}

void complexToIShortMulti(std::vector<uint32_t> &out, const std::vector<std::complex<double>> &vec) {
    complexToIShortMulti(out, vec.data(), vec.size());
}

void complexToIShortMulti(std::vector<uint32_t> &out, const unsigned char *data, const size_t length) {
    complexToIShortMulti(out, (const std::complex<double>* const)data, length);
}

// data is a pointer to raw memory, length is the number of uint32_t we expect to find there (not number of bytes)
void complexToIShortMulti(std::vector<uint32_t> &out, const std::complex<double> *data, const size_t length) {
    constexpr double gain = 0x7fff;
    out.resize(0);
    out.reserve(length);

    int32_t re,im;
    uint32_t sout;
    for( size_t i = 0; i < length; i++ ) {
        std::complex<double> s = data[i];

        im = s.imag() * gain;
        re = s.real() * gain;

        sout = ((im<<16)) | (re&0xffff);

        out.emplace_back(sout);
    }
}


void complexConjMult(
    std::vector<std::complex<double>> &out,
    const std::vector<std::complex<double>> &a,
    const std::vector<std::complex<double>> &b ) {
    out.resize(0);

    auto len = std::min(a.size(),b.size());

    out.reserve(len);

    for(size_t i = 0; i < len; i++) {
        auto r = a[i] * std::conj(b[i]);
        out.push_back(r);
    }
}

void complexMult(
    std::vector<std::complex<double>> &out,
    const std::vector<std::complex<double>> &a,
    const std::vector<std::complex<double>> &b ) {
    out.resize(0);

    auto len = std::min(a.size(),b.size());

    out.reserve(len);

    for(size_t i = 0; i < len; i++) {
        auto r = a[i] * b[i];
        out.push_back(r);
    }
}

void rotateIShortMulti(std::vector<uint32_t> &out, const std::vector<uint32_t> &in, double rads) {
    // out.resize(0);

    std::vector<std::complex<double>> ascp;
    std::vector<std::complex<double>> rot;
    std::vector<std::complex<double>> rotby;

    // for(int i = 0; i < 1024; i += 32) {
    //     cout << HEX32_STRING(waste[i]) << "\n";
    // }

    IShortToComplexMulti(ascp, in);

    double rad = rads;//3.1415/2;

    const std::complex<double> s = {cos(rad),sin(rad)};

    for(unsigned i = 0; i < ascp.size(); i++) {
        rotby.push_back(s);
    }

    complexMult(rot, ascp, rotby);

    complexToIShortMulti(out, rot);
    // return out;
}

// accepts a complex number, and returns what riscv would return from ATAN()
// only returns ANGLE part
uint32_t riscvATANComplex(const std::complex<double> cplx, const size_t shift) {

  if( shift != 15 ) {
    // throw(new Error('shift of 15 was the only version tested'));
    std::cout << "shift of 15 was the only version tested" << std::endl;
    return 0;
  }
  // calculated by observation
  const double arg_factor = 10430.0;
  const double mag_factor = 13490.45;

  const double mag = std::abs(cplx); //mt.abs(cplx);
  double arg = std::arg(cplx); //.arg();

  if( arg < 0 ) {
    arg += 2*M_PI;
  }

  if( arg < 0 ) {
    std::cout << "ERROR: got negative angle after adding 2 pi, forcing to 0" << std::endl;
    arg = 0;
  }

  size_t magint = (size_t) std::round(mag * mag_factor);
  size_t argint = (size_t) std::round(arg * arg_factor);

  // bound magnitude
  if( magint > 0xffff ) {
    magint = 0xffff;
  }

  // bound arg, not sure if this will ever happen
  if( argint > 0xffff ) {
    argint = 0xffff;
  }

  uint32_t res = (uint32_t)((magint << 16) | argint);

  return res;
}

uint32_t riscvATAN(uint32_t val, const size_t shift) {
    std::vector<std::complex<double>> wasteful;
    IShortToComplexMulti(wasteful, &val, sizeof(val)); // use data*, length version
    auto arg = wasteful[0];
    return riscvATANComplex(arg);
}

// https://download.samba.org/pub/unpacked/ntdb/lib/ccan/time/time.c

uint64_t time_to_usec(struct timeval t)
{
    uint64_t usec;

    usec = t.tv_usec + (uint64_t)t.tv_sec * 1000000;
    return usec;
}

struct timeval time_from_msec(uint64_t msec)
{
    struct timeval t;

    t.tv_usec = (msec % 1000) * 1000;
    t.tv_sec = msec / 1000;
    return t;
}

struct timeval time_divide(struct timeval t, unsigned long div)
{
    return time_from_usec(time_to_usec(t) / div);
}

struct timeval time_multiply(struct timeval t, double mult)
{
    return time_from_usec(time_to_usec(t) * mult);
}

uint64_t time_to_msec(struct timeval t)
{
    uint64_t msec;

    msec = t.tv_usec / 1000 + (uint64_t)t.tv_sec * 1000;
    return msec;
}

struct timeval time_from_usec(uint64_t usec)
{
    struct timeval t;

    t.tv_usec = usec % 1000000;
    t.tv_sec = usec / 1000000;
    return t;
}


void unwrap_phase_inplace(std::vector<double>&cfo_angle)
{
    const unsigned wanted = cfo_angle.size();

    std::vector<double> angle_n(wanted, 0.0);
    double temp_angle_n = 0.0;
    for(unsigned index = 1; index < wanted; index++)
    {
        if(cfo_angle[index]-cfo_angle[index-1]>=M_PI)
        {
            temp_angle_n = temp_angle_n - 2.0;
        }
        else if(cfo_angle[index]-cfo_angle[index-1]<M_PI*(-1.0))
        {
            temp_angle_n = temp_angle_n + 2.0;
        }
        angle_n[index] = temp_angle_n;
    }

    for(unsigned index = 1; index < wanted; index++)
    {
        cfo_angle[index] = cfo_angle[index] + (angle_n[index]*M_PI);
    }
}

/// Calculate fixed point magnitude squared for a vector if ishort
/// returns uint64_t for ease of work
/// returns maximum uint64_t value for overflow.  will return early in this case
uint64_t riscv_mag2_ideal(const std::vector<uint32_t>& in, const unsigned rshift = 0) {

    uint64_t pow = 0;
    uint64_t previous = 0;


    for(const auto w : in) {
        int16_t _imag;
        int16_t _real;

        ishort_to_parts(w, _imag, _real);

        int64_t imag = _imag;
        int64_t real = _real;

        // this is mag squared
        int64_t mag = ((imag*imag) + (real*real)) >> rshift;

        if( mag < 0 ) {
            std::cout << "riscv_mag2_ideal() sample wise overflow\n";
        }

        pow += mag;

        if( previous > pow ) {
            std::cout << "riscv_mag2_ideal() overflowed\n";
            return 0xffffffffffffffff; // return maximum value
        }

        previous = pow;
    }

    return pow;
}


// doesn't exactly belong here in FileUtils, but at least its under a namespace and accessible from both
// smodem and tb
std::vector<uint32_t> offsetWords(const std::vector<uint32_t> data, const unsigned length, const unsigned offset) {
    std::vector<uint8_t> chars;
    const uint8_t* aschar = (const uint8_t*)data.data();
    for(unsigned int i = offset; i < data.size()*4; i++) {
        chars.push_back(aschar[i]);
    }
    // cout << "\n\n";
    // for( const auto w : chars ) {
    //     cout << HEX32_STRING((int)w) << "\n";
    // }
    const uint32_t* aswords = (const uint32_t*) chars.data();
    std::vector<uint32_t> out;
    for(unsigned int i = 0; i < length; i++) {
        out.push_back(aswords[i]);
    }

    return out;
}

std::vector<uint8_t> wordsIntoChars(const std::vector<uint32_t> data, const unsigned length, const unsigned offset) {
    std::vector<uint8_t> chars;
    const uint8_t* aschar = (const uint8_t*)data.data();
    for(unsigned int i = offset; i < data.size()*4; i++) {
        chars.push_back(aschar[i]);
    }
    
    //cout << "\n\n";
    // for( const auto w : chars ) {
    //    cout << HEX32_STRING((int)w) << "\n";
    // }
    
    chars.resize(length);
    return chars;
}

// #include "cpp_utils.hpp"


// when subcarriers go through tx and then rx fft
// the 0th subcarrier stays the same
// the other 1023 are reversed in order
std::vector<uint32_t> fftAirSubcarrierTransform(const std::vector<uint32_t>& v) {

    const unsigned vlen = v.size() - (v.size()%1024);

    if(vlen != v.size()) {
        std::cout << "fftAirSubcarrierTransform() output will be a frame short due to input not being divisible by 1024\n";
    }

    std::vector<uint32_t> out;
    out.resize(vlen);

    for(unsigned i = 0; i < vlen; i+=1024) {
        out[i] = v[i];
        for(unsigned j = 1; j < 1024; j++) {
            unsigned k = i+j;
            unsigned rout = (1023 - j) + 1;
            unsigned wout = rout + i;
            out[wout] = v[k];
        }
    }

    return out;
}


std::vector<uint32_t> vectorInsertTrunk(
    const std::vector<uint32_t>& v,
    const unsigned counter_index,
    const uint32_t counter_start) {

    if( counter_index >= 16 ) {
        std::cout << "counter_index cannot be larger than 15\n";
        return {};
    }

    uint32_t running_counter = counter_start;

    std::vector<uint32_t> out;
    out.reserve( 1040*v.size()/1024 );

    for(unsigned i = 0; i < v.size(); i++) {
        out.push_back(v[i]);
        if( i % 1024 == 1023 ) {
            std::vector<uint32_t> trunk;
            trunk.resize(16);
            trunk[counter_index] = running_counter;
            out.insert(out.end(), trunk.begin(), trunk.end());
            running_counter++;
        }
    }

    return out;
}


// converts a string to uint32_t word vector
// any non multiple of 4 is padded by spaces
std::vector<uint32_t> stringToWords(const std::string &_in) {
    
    std::string in = _in;
    const unsigned original_size = in.size();
    
    switch(original_size%4) {
        case 1:
            in += "   ";
            break;
        case 2:
            in += "  ";
            break;
        case 3:
            in += " ";
            break;
        case 0:
        default:
            break;
    }
    
    
    std::vector<uint32_t> res;
    res.reserve( (original_size/4) + 1 );
    
    uint32_t w = 0;
    
    unsigned i = 0;
    for(const auto c : in) {
        const unsigned pos = i % 4;
        const unsigned shift = pos * 8;
        
        w |= ((unsigned)c) << shift;
        
        //cout << "pos: " << pos << " shift " << shift << " " << HEX32_STRING(w) << " " << c << " " << HEX32_STRING((int)c) << "\n";
        
        if( pos == 3 ) {
            res.push_back(w);
            w = 0;
        }
        
        i++;
    }
    
    return res;
}