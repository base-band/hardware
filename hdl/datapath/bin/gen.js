#!/usr/bin/env node
'use strict';

const templates = require('../templates.js');
const path = require('path');
const fs = require('fs-extra');

const log2slices = 4;
const slices = 1 << log2slices;
const log2sections = 1;
const sections = 1 << log2sections;

const props = {
    dataWidth: 32,
    narrowWidth: 18,
    wideWidth: 36,
    law: {
        inmux: [1, 2, 7],
        oumux: [8, 9, 10, 11, 14, 15],
        selin: 4,
        selou: 4,
        perin: 5,
        perou: 5,
        baddr: 11,
        k15: 32
    },
    log2slices: log2slices,
    slices: slices,
    sections: sections,
    funnel: {
        minWidth: 4, // 4x18-bit outputs
        maxWidth: 4 * sections, // 16x18-bit outputs
        steps: 3 // 64:4 64:8 64:16
    },
    cfg: [
        8, 8, 8, 8, 8, 8, 8, 8, // bs
        8, 8, 8 // funnel funnel defunnel
    ]
};

const fineGrain = {
    // 'rdp_x_demux.v': [[2], [3], [4], [5], [6], [7], [8], [9], [10]],
    // 'rdp_x_mux.v': [[2], [3], [4], [7], [8], [9]],
    // 'rdp_x_mulc.v': [
    //     ['00', 0.38269043],
    //     ['01', 0.54119873],
    //     ['03', 0.707092285],
    //     ['05', 1.30657959],
    //     ['06', 0.923828125]
    // ],
    'bs_dat.v': [[2, 1]],

    'funnel_dat.v':    [[2, 2], [2, 4]],
    'funnel_ctrl.v':   [[2, 2], [2, 4]],

    'defunnel_dat.v':  [[3, 1], [5, 1]],
    'defunnel_ctrl.v': [[3, 1], [5, 1]]
};

Object.keys(templates).forEach(fileName => {
    const extName = path.extname(fileName);
    const baseName = path.basename(fileName, extName);
    (fineGrain[fileName] || [[]]).forEach(subUnit => {
        const body = templates[fileName](Object.assign({local: subUnit}, props));
        const outPath = path.resolve(process.cwd(), 'hdl', baseName + subUnit.map(e => '_' + e).join('') + extName);
        fs.outputFile(
            outPath,
            body,
            'utf-8',
            function (err) { if (err) { throw err; } }
        );
    });
});
