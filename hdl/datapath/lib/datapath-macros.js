'use strict';

const reqack = require('reqack');
const range = require('lodash.range');
const forkCtrl = reqack.ctrl.fork;
const deconcat = reqack.macros.deconcat;

module.exports = {
    funnel: {
        // ctrl: p => `funnel_ctrl unode${p.id} ();`,
        ctrl2data: p => [
            ['sel',  'nsel'  + p.id,  8],
            ['mode', 'nmode' + p.id, -8]
        ]
    },
    defunnel: {
        // ctrl: p => `defunnel_ctrl unode${p.id} ();`,
        ctrl2data: p => [
            ['enable',  'enable'  + p.id,  8],
            ['mode', 'mode' + p.id, -8]
        ]
    },
    bs: {
        ctrl: p => `// node:${p.id} bs
assign req${p.i[0]} = req${p.t[0]};
assign ack${p.t[0]} = ack${p.i[0]};
assign ack${p.t[1]} = 1'b1;`
    },
    round_sat: {
    },
    addsub: {
        ctrl: p => `// node:${p.id} addsub
assign ack${p.t[1]} = 1'b1;
reg req${p.i[0]}_r;
assign req${p.i[0]} = req${p.i[0]}_r;
assign n${p.id}_en = req${p.t[0]} & ack${p.t[0]}; //${p.t.valid} & ${p.t.ready};
assign ack${p.t[0]} = ~req${p.i[0]}_r | ack${p.i[0]};
always @(posedge clk or negedge reset_n) if (~reset_n) req${p.i[0]}_r <= 1'b0; else req${p.i[0]}_r <= ~ack${p.t[0]} | req${p.t[0]};`,
        data: p => {
            const width = p.t[0].width;
            const lhs = `${p.t[0].wire}[${width - 1}:${width / 2}]`;
            const rhs = `${p.t[0].wire}[${width / 2 - 1}:0]`;
            // should map to ALU54B primitive
            return `
// assign ${p.i[0].wire} = ${p.t[1].wire}[0] ? (${lhs} - ${rhs}) : (${lhs} + ${rhs});
wire n${p.id}_en;
alu54b_wrapper addsub${p.id} (
    .a(${lhs}),
    .b(${rhs}),
    .c(${p.i[0].wire}),
    .subadd(${p.t[1].wire}),
    .ce(n${p.id}_en),
    .clk(clk),
    .rst(~reset_n)
);
`;
            // return `assign ${p.i[0].wire} = (${lhs} - ${rhs});`;
        },
        ctrl2data: p => [
            ['ene',  'n' + p.id + '_en', 1]
        ]
    },
    muladdsub: {
        ctrl: p => `// node: ${p.id} muladdsub
assign ack${p.t[1]}=1'b1;

//stage 1
reg req${p.i[0]}_s1_r;
wire req${p.i[0]}_s1,ack${p.i[0]}_s1;

assign req${p.i[0]}_s1 = req${p.i[0]}_s1_r;
assign n${p.id}s1_en = req${p.t[0]} & ack${p.t[0]};
assign ack${p.t[0]} = ~req${p.i[0]}_s1_r | ack${p.i[0]}_s1;
always @(posedge clk or negedge reset_n) if(~reset_n) req${p.i[0]}_s1_r <= 1'b0; else req${p.i[0]}_s1_r <= ~ack${p.t[0]} | req${p.t[0]};

//stage 2
reg req${p.i[0]}_s2_r;
wire req${p.i[0]}_s2,ack${p.i[0]}_s2;

assign req${p.i[0]}_s2 = req${p.i[0]}_s2_r;
assign n${p.id}s2_en = req${p.i[0]}_s1 & ack${p.i[0]}_s1;
assign ack${p.i[0]}_s1 = ~req${p.i[0]}_s2_r | ack${p.i[0]}_s2;
always @(posedge clk or negedge reset_n) if(~reset_n) req${p.i[0]}_s2_r <= 1'b0; else req${p.i[0]}_s2_r <= ~ack${p.i[0]}_s1 | req${p.i[0]}_s1;

//stage 3
reg req${p.i[0]}_s3_r;

assign req${p.i[0]} = req${p.i[0]}_s3_r;
assign n${p.id}s3_en = req${p.i[0]}_s2 & ack${p.i[0]}_s2;
assign ack${p.i[0]}_s2 = ~req${p.i[0]}_s3_r | ack${p.i[0]};
always @(posedge clk or negedge reset_n) if(~reset_n) req${p.i[0]}_s3_r <= 1'b0; else req${p.i[0]}_s3_r <= ~ack${p.i[0]}_s2 | req${p.i[0]}_s2;
`,
        data: p => {
            const width = p.t[0].width;
            const a0 = `n${p.id}_a0`;
            const b0 = `n${p.id}_a1`;
            const a1 = `n${p.id}_b0`;
            const b1 = `n${p.id}_b1`;

            return `
wire n${p.id}s1_en;
wire n${p.id}s2_en;
wire n${p.id}s3_en;

wire [${width / 4 - 1}:0] ${a0}, ${a1}, ${b0}, ${b1};
assign {${b1}, ${a1}, ${b0}, ${a0}} = ${p.t[0].wire};

muladdsub muladdsub${p.id} (
    .CLK0(clk),
    .RST0(~reset_n),
    .CE0(n${p.id}s1_en),
    .CE1(n${p.id}s2_en),
    .CE2(n${p.id}s3_en),
    .ADDNSUB(${p.t[1].wire}[0]),
    .A0(${a0}),
    .A1(${a1}),
    .B0(${b0}),
    .B1(${b1}),
    .SUM(${p.i[0].wire})
);
`;
        },
        ctrl2data: p => [
            ['ene1', 'n' + p.id + 's1_en', 1],
            ['ene2', 'n' + p.id + 's2_en', 1],
            ['ene3', 'n' + p.id + 's3_en', 1]
        ]
    },

    deconcat: deconcat,
    slice16: {
        data: p => {
            const rhs = p.t[0].wire;
            const step = 16;
            return p.i.map((sig, sigi) => `assign ${sig.wire} = {{${sig.width - step + 1}{${rhs}[${step * sigi + step - 1}]}}, ${rhs}[${step * sigi + step - 2}:${step * sigi}]};`).join('\n');
        },
        ctrl: forkCtrl // p => JSON.stringify(p, null, 4)
    },
    m2c: {
        data: p => {
            const inputs = p.t.length - 1;
            const selector = p.t[inputs].wire;
            const iw = [0, 1, 2, 3].map(idx =>
                (idx < inputs) ? p.t[idx].wire : '1'
            );
            return `
wire [1:0] n${p.id}sel; assign n${p.id}sel = ${selector};
assign ${p.i[0].wire} =
    (n${p.id}sel == 2'b00) ? ${iw[0]} :
    (n${p.id}sel == 2'b01) ? ${iw[1]} :
    (n${p.id}sel == 2'b10) ? ${iw[2]} : ${iw[3]};
`;
        },
        ctrl: p => {
            const inputs = p.t.length - 1;
            const selector = p.t[inputs];
            const iw = [0, 1, 2, 3].map(idx =>
                (idx < inputs) ? 'req' + p.t[idx] : '1'
            );
            const acks = range(inputs).map(idx =>
`assign ack${p.t[idx]} = (n${p.id}sel != ${idx}) | ack${p.i[0]};`
            );
            return `// node:${p.id} m2c
assign req${p.i[0]} =
    (n${p.id}sel == 2'b00) ? ${iw[0]} :
    (n${p.id}sel == 2'b01) ? ${iw[1]} :
    (n${p.id}sel == 2'b10) ? ${iw[2]} : ${iw[3]};
${acks.join('\n')}
assign ack${selector} = 1'b1;
`;
        },
        ctrl2data: p => [
            ['sel', 'n' + p.id + 'sel', -2]
        ]
    }
};
