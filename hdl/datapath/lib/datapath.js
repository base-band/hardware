'use strict';

const radix4genGen = require('./radix4');
const cmulGenGen = require('./cmul');
const range = require('lodash.range');

// const range = require('lodash.range');

// const nSlices = 4;
// const s16 = {width: 16};
const rs16 = {width: 16, capacity: 1};
const rs16_15 = {width: 16, capacity: 1.5};
const s18 = {width: 18};
// const rs18 = {width: 18, capacity: 1};
// const s36 = {width: 36};
// const rs36 = {width: 36, capacity: 1};
// const s36 = {width: 36};
// const s4 = {width: 4};
const rs8 = {width: 8, capacity: 1};
const rs8_0 = {width: 8, capacity: 0};
const rs20 = {width: 20, capacity: 1.5};
// const kw = {width: 32 * 32};
// const rs72 = {width: 72, capacity: 1};

module.exports = function (g, params) {
    const cmulGen = cmulGenGen(g);

    params = params || {};
    const nSlices = params.slices || 16;
    const nSections = params.sections || 8;
    const radix = 4;

    const rkw = {width: nSlices * 32, capacity: 1.5};

    return function (dpTargets) {

        // const k1 = g('k1');
        // const k2 = g();
        const k8 = dpTargets.k8;
        const k9 = dpTargets.k9;
        // const k10 = g();
        // const k11 = g();
        const k14 = dpTargets.k14;

        const iport8 = g('funnel');
        const iport9 = g('funnel');
        const oport1 = g('defunnel');
        const cfg = g('deconcat');

        k8(iport8);
        k9(iport9);
        const k1 = oport1(rkw);

        const radix4gen = radix4genGen(g, {width: 36, capacity: 1}, cfg);

        range(nSections >> 2)
            .map(() => {
                const iport8chunk = g('slice16');
                const iport9chunk = g('slice16');
                iport8({width: radix * 2 * 16, capacity: 1})(iport8chunk);
                iport9({width: radix * 2 * 16, capacity: 1})(iport9chunk);
                return range(radix)
                    .map(() => [
                        {re: iport8chunk(s18), im: iport8chunk(s18)},
                        {re: iport9chunk(s18), im: iport9chunk(s18)},
                        cfg
                    ])
                    .map(cmulGen);
            })
            .map(radix4gen)
            .map(e => {
                const oport1chunk = g('concat');
                oport1chunk({width: radix * 2 * 16})(oport1);
                return e
                    .map(ee => {
                        const node = {re: g('bs'), im: g('bs')};
			const node1 = {re: g('round_sat'), im: g('round_sat')};
                        ee.re(node.re);
                        ee.im(node.im);
                        cfg(rs8_0)(node.re, 'cfg');
                        cfg(rs8_0)(node.im, 'cfg');
			node.re(rs20)(node1.re);
                        node.im(rs20)(node1.im);
                        return {
                            re: node1.re(rs16),
                            im: node1.im(rs16)
                        };
                    })
                    .map(ee => {
                        ee.re(oport1chunk);
                        ee.im(oport1chunk);
                    });
            });

        k14(cfg);
        cfg(rs8_0)(iport8, 'cfg');
        cfg(rs8_0)(iport9, 'cfg');
        cfg(rs8_0)(oport1, 'cfg');

        return {
            k1: k1
        };
    };
};
