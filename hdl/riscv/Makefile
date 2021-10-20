
.PHONY: all genriscv

all: genriscv

genriscv:
	cp scala/DemapperCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/plugin/
	cp scala/DEngineCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/plugin/
	cp scala/CsrPlugin.scala VexRiscv/src/main/scala/vexriscv/plugin/
	cp scala/GenericOutCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/SatDetectCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/ControlStatusCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/MapperMoverCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/InterruptCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/TimerCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/DmaCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/GpioCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/MuraxUtiles.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/RingBusCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/NCOCsrPlugin.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/Xbaseband.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/XbbVectorCordic.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/XbbRiscv.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/Briey.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/Murax.scala VexRiscv/src/main/scala/vexriscv/demo/
	cp scala/Services.scala VexRiscv/src/main/scala/vexriscv/
	cp scala/XbbRiscvUtiles.scala VexRiscv/src/main/scala/vexriscv/demo/
	cd VexRiscv  &&	sbt "run-main vexriscv.demo.XbbRiscv"
	cp VexRiscv/XbbRiscv.v hdl/generated/
	cd VexRiscv  &&	sbt "run-main vexriscv.demo.XbbRiscvWithRam"
	rm -f hdl/generated/VexRiscv.v
	sed -i 's| \?/\* \?verilator public \?\*/ \?||g' hdl/generated/XbbRiscv.v
	#sed -i 's|wire \[31:0\] writeBack_PC;|wire \[31:0\] writeBack_PC;\n  define CUSTOM_VERILATOR_PUBLIC_32(sig) function[31:0] get_`sig``; /verilator public/   begin   get_``sig`` = sig;   end endfunction  \n   ifdef VERILATE_DEF \n    CUSTOM_VERILATOR_PUBLIC_32(writeBack_PC)  \n `endif \n  |g'   hdl/generated/XbbRiscv.v
	cat hdl/generated/XbbRiscv.v | sed 's/\(ram \[.*\);/\1 \/\* synthesis syn_ramstyle = "registers" \*\/;/' > hdl/generated/XbbRiscvNoEBR.v
