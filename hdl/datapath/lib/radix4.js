'use strict';

const s2 = {width: 2};

module.exports = (g, ltype, cfg) => {

    const ltypePlus  = {width: ltype.width, capacity: 1.5};
    const ltypeMinus = {width: ltype.width};

    const radix4a = t => {
        const nodes = [
            {re: 'add', im: 'add'},
            {re: 'add', im: 'add'},
            {re: 'sub', im: 'sub'},
            {re: 'sub', im: 'sub'}
        ].map(e => ({re: g(e.re), im: g(e.im)}));

        return [[0, 2], [1, 3], [0, 2], [1, 3]]
            .map((e, ei) =>
                e
                    .map(ee => ({
                        re: t[ee].re(nodes[ei].re),
                        im: t[ee].im(nodes[ei].im)
                    }))
            )
            .map((e, ei) => ({
                re: nodes[ei].re(ltypePlus),
                im: nodes[ei].im(ltypePlus)
            }));
    };

    const radix4b = t => [
        {re: t[0].re, im: t[0].im},
        {re: t[2].re, im: t[2].im},
        {re: t[1].re, im: t[1].im},
        {re: t[3].im, im: t[3].re} // first part of conj.
    ];

    const radix4c = t => {
        const nodes = [
            {re: 'add', im: 'add'},
            {re: 'add', im: 'sub'}, // second part of conj.
            {re: 'sub', im: 'sub'},
            {re: 'sub', im: 'add'}  // second part of conj.
        ].map(e => ({re: g(e.re), im: g(e.im)}));

        return [[0, 2], [1, 3], [0, 2], [1, 3]]
            .map((e, ei) =>
                e
                    .map(ee => ({
                        re: t[ee].re(nodes[ei].re),
                        im: t[ee].im(nodes[ei].im)
                    }))
            )
            .map((e, ei) => ({
                re: nodes[ei].re(ltypeMinus),
                im: nodes[ei].im(ltypeMinus)
            }));
    };

    const bypass = (out, inp) =>
        out.map((el, i) => {
            const ns = {re: g('m2c'), im: g('m2c')};
            inp[i].re(ns.re);
            out[i].re(ns.re);
            inp[i].im(ns.im);
            out[i].im(ns.im);
            cfg(s2)(ns.re, 'cfg');
            cfg(s2)(ns.im, 'cfg');
            return {
                re: ns.re(ltype),
                im: ns.im(ltype)
            };
        });

    return t => {
        const res = bypass(radix4c(radix4b(radix4a(t))), t);
        return res;
    };

};
