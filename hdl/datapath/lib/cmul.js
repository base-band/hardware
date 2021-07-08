'use strict';

const rs72 = {width: 72, capacity: 1.5};
const s72 = {width: 72};
const rs36 = {width: 36, capacity: 1};
const s18  = {width: 18};
const rs18  = {width: 18, capcity: 1.5};
const s36  = {width: 36};
const s2  = {width: 2};

module.exports = g => t => {
    const i = {
        a: t[0].re,
        b: t[0].im,
        c: t[1].re,
        d: t[1].im
    }; // a b c d

    const cfg = t[2];

    const x0 = [        [
            [
                [i.a],
                [i.a, i.c]
            ],
            [
                [i.b, i.c],
                [i.b, i.d]
            ]
        ],
        [
            [
                [i.c, i.b],
                [i.c, i.d]
            ],
            [
                [i.d],
                [i.d, i.a]
            ]
        ]
    ];

    const x1 = x0.map(e0 =>
        e0.map(e1 =>
            e1
                .map(e2 => {
                    if (e2.length === 1) {
                        return e2[0];
                    }
                    const n = g('m2c');
                    e2.map(e3 => e3(n));
                    cfg(s2)(n, 'cfg');
                    return n(s18);
                })
        )
    );

    const x2 = x1.map(e0 => {
        const n = g('concat');
        e0.map(e1 =>
            e1.map(e2 => e2(n))
        );
        return n(rs72);
    });

    const x3 = x2.map(e0 => {
        const n = g('muladdsub');
        e0(n);
        cfg(s2)(n, 'cfg');
        return n(s36);
    });

    return {re: x3[0], im: x3[1]};
};
