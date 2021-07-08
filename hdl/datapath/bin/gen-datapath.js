#!/usr/bin/env node
'use strict';

const fs = require('fs-extra');

const datapath = require('../lib/datapath.js');
const macros = require('../lib/datapath-macros');
const reqack = require('reqack');

const g = reqack.circuit('datapath');

const nSlices = 16;
const nSections = 2;

const rkw = {width: nSlices * 32, capacity: 1};

// target ports
const dpTargets = {
    k8: g('k8')(rkw),
    k9: g('k9')(rkw),
    k14: g('k14')(rkw)
};

const dpInitiators = datapath(g, {
    nSlices: nSlices,
    nSections: nSections
})(dpTargets);

dpInitiators.k1(g('k1'), 'k1');

// initiator ports

g.nodes.map((n, ni) => {
    if (n.label === 'deconcat') {
        console.log('deconcat' + ni);
        let offset = 0;
        n.to.map(e => {
            const width = e.label.width;
            e.targets.map(t => {
                console.log(t.node.label, offset, width);
            });
            offset += width;
        });
    }
});

fs.outputFile('hdl/datapath.dot', reqack.dot(g), () => {
    fs.outputFile('hdl/datapath.v', reqack.verilog(g, macros), () => {
        fs.outputFile('hdl/project.js', reqack.manifest(g, 'datapath'), () => {});
    });
});
