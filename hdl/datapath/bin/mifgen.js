#!/usr/bin/env node
'use strict';

const fs = require('fs-extra');
const path = require('path');
const math = require('mathjs');
const range = require('lodash.range');

// generate data sets for datapath testing

const scale = 1 << 14;

function num2hex (num) {
    const data1 = scale * num;
    const data2 = data1 >>> 0;
    const data3 = ('00000000' + data2.toString(16)).slice(-4);
    return data3;
}

function num8 (datum, tail) {
    return []
        .concat((
            '          ' +
            Number(math.format(datum, {precision: 5, notation: 'fixed'}))
        ).slice(-8))
        .concat(tail);
}

function cplx2hex (data) {
    const tmp = data.reduce((res, datum) => {
        res.re = num8(datum.re, res.re);
        res.im = num8(datum.im, res.im);
        res.hex = [num2hex(datum.im) + num2hex(datum.re)].concat(res.hex);
        if ((res.i += 1) === 32) {
            return {
                dump: res.dump
                    + '// ' + res.re.join(' ')
                    + '\n// ' + res.im.join(' ')
                    + '\n   ' + res.hex.join('_') + '\n',
                i: 0,
                hex: [],
                re: [],
                im: []
            };
        }
        return res;
    }, {i: 0, hex: [], re: [], im: [], dump: ''});
    return tmp.dump;
}

fs.outputFile(
    path.resolve('hdl', 't_k8_dat.mif'),
    cplx2hex(range(1024)
        // .map(idx => idx)
        // .map(phi => math.complex(
        //     math.cos(phi),
        //     math.sin(phi)
        // ))
        .map(phi => math.complex(
            phi / (1 << 14),
            0
        ))
    ),
    err => { if (err) { throw err; } }
);

fs.outputFile(
    path.resolve('hdl', 't_k9_dat.mif'),
    cplx2hex(range(1024)
        // .map(phi => math.pi * phi / 128)
        .map(() => 0)
        .map(phi => math.complex(
            math.cos(phi),
            math.sin(phi)
        ))
    ),
    err => { if (err) { throw err; } }
);

fs.outputFile(
    path.resolve('hdl', 't_k14_dat.mif'),
    range(32).map(() =>
        '040404' + range(32).map(() => '05').join('')
    ).join('\n'),
    err => { if (err) { throw err; } }
);
