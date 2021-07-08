'use strict';

module.exports = {
    data: p => {
        const targets = p.t.map((sig, sigi) => `.t_${sigi}_data(${sig.name})`);
        const initiators = p.i.map((sig, sigi) => `.i_${sigi}_data(${sig.name})`);
        const ports = targets.concat(initiators);
        return `defunnel_data${p.t.length - 1} udefunnel_data${p.id} (
${ports.map(line => '    ' + line).join(',\n') },
    .sel(sel), .clk(clk), .reset_n(reset_n)
);
`;
    },
    ctrl: () => '// defunnel',
    ctrl2data: () => ({
        sel: 4
    })
};
