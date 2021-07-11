#pragma once

#include <string>
// #include <array>
// #include <stdint.h>
// #include <vector>
#include <chrono>

typedef std::pair<int, std::string> cmd_run_t;

class CmdRunner
{
private:
    std::chrono::steady_clock::time_point started;
public:
    static cmd_run_t runOnce(std::string c, bool supressThrow=false, bool captureBoth=true, bool debugCommand=false); // named constructor
    static cmd_run_t runOnceDebug(std::string c, bool supressThrow=false, bool captureBoth=true); // named constructor
    // static CmdRunner createCmdVersionTwo() { return CmdRunner("ls"); }  // named constructor
    
    std::string cmd_stdoutput;
    int cmd_retval;
    int cmd_sys_retval; // use this to get identical to echo $?

    std::string getOutput();
    CmdRunner(std::string, bool supressThrow=false, bool captureBoth=true, bool debugCommand=false);

};


// ideas
//  https://en.wikibooks.org/wiki/More_C%2B%2B_Idioms/Named_Constructor