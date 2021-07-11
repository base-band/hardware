#include <cstdio>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <array>

#include "CmdRunner.hpp"


// FIXME this could be moved somewhere globally?
// template <typename Iter>
// static std::string _join(Iter begin, Iter end, std::string const& separator)
// {
//   std::ostringstream result;
//   if (begin != end)
//     result << *begin++;
//   while (begin != end)
//     result << separator << *begin++;
//   return result.str();
// }

// int pclose(FILE *stream);


// do nothing
static void _pclose(FILE *stream) {
    // int i  = 4;
    // std::cout << "in _pclose()" << std::endl;
}

// This guy returns 255 instead of 1. See these:
// https://stackoverflow.com/questions/6459023/exec-returning-255
// http://pubs.opengroup.org/onlinepubs/009695399/functions/exit.html


// FIXME this doesn't caputer stderror?
static std::pair<int, std::string> _exec(const char* cmd) {
    constexpr int max_return_bytes = 128; // and or read size?
    std::array<char, max_return_bytes> buffer;
    std::string result;
    

    // haked example
    FILE *as_file = popen(cmd, "r");
    std::shared_ptr<FILE> pipe(as_file, _pclose);
    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }

    while (!feof(pipe.get())) {
        if (fgets(buffer.data(), max_return_bytes, pipe.get()) != nullptr)
            result += buffer.data();
    }
    int foo = pclose(as_file);
    // std::cout << "foo: " << foo << std::endl;

    return std::make_pair(foo, result);
}

CmdRunner::CmdRunner(std::string c, bool supressThrow, bool captureBoth, bool debugCommand) {
    // 

    std::string final_execute = c;

    if( captureBoth ) {
        final_execute.append(" 2>&1");
    }

    if( debugCommand ) {
        std::cout << "CmdRunner() will run this command: " << std::endl << "  " <<
        final_execute << std::endl;
    }


    auto packed = _exec(final_execute.c_str()); // FIXME this doesn't caputer stderror?
    cmd_retval = std::get<0>(packed);
    cmd_stdoutput = std::get<1>(packed);

    // I think this is right? Seems to match results of echo $?
    cmd_sys_retval = cmd_retval % 0xFF;
}

std::string CmdRunner::getOutput() {
    return cmd_stdoutput;
}



cmd_run_t CmdRunner::runOnce(std::string c, bool _1, bool _2, bool _3) {
        CmdRunner t = CmdRunner(c, _1, _2, _3);
        auto i = t.cmd_stdoutput;
        auto r = t.cmd_sys_retval;

        return std::make_pair(r, i);
    }

cmd_run_t CmdRunner::runOnceDebug(std::string c, bool supressThrow, bool captureBoth) {
    return CmdRunner::runOnce(c, supressThrow, captureBoth, true);
}