#include <stdlib.h>
#include <iostream>
#include <vector>
#include <bitset>
#include <assert.h>
#include <verilated.h>
#include <sys/stat.h>
#include <fstream>
#include "Vtb_higgs_top.h"
#include "Vtb_higgs_top__Syms.h"
#include "cpp_utils.hpp"
#include "feedback_bus_tb.hpp"
#include <verilated_vcd_c.h>
#include "higgs_helper.hpp"
#include "piston_c_types.h"
#include "vmem_types.h"

typedef Vtb_higgs_top top_t;
typedef HiggsHelper<top_t> helper_t;

VerilatedVcdC* tfp = NULL;
// Construct the Verilated model, from Vtop.h generated from Verilating "top.v"
// Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper
top_t* top = new top_t;
// Current simulation time (64-bit unsigned)
uint64_t main_time = 0;
// Called by $time in Verilog
double sc_time_stamp () {
    return main_time; // Note does conversion to real, to match SystemC
}

int main(int argc, char** argv, char** env) {
    STANDARD_TB_START();

    HiggsHelper<top_t>* t = new HiggsHelper<top_t>(top,&main_time,tfp);

    srand(42);

    preReset(top);

    t->reset(40);

    postReset(top);

    t->uarts["cs22"]->print = false;
    t->uarts["cs22"]->print3 = true;
    t->uarts["cs22"]->print_chars = false;
    t->uarts["cs22"]->disable_parse = true;

    std::vector<uint32_t> din;

    t->tick(300);

    for(int i = 0; i < 32; i++) {
        din.push_back(0xf0ff0000 | i);
    }


    t->inStreamAppend("cs31in", din);

    t->tick(2048);

    // t->tick(1024*10);

    for(const auto w : t->outs["ethout"]->data) {
        cout << HEX32_STRING(w) << "\n";
    }

    assert(t->outs["ethout"]->data.size() == 32 && "Got wrong size");

    for(int i = 0; i < 32; i++) {
        assert(t->outs["ethout"]->data[i] == (din[i]|0x0f000000) );
    }


    // auto x = t->uarts['cs22'];

    
    exit(0);
}
